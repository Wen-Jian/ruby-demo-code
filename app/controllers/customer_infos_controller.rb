include ApplicationHelper

class CustomerInfosController < ApplicationController
    PerPageCount = 30
    PageNumber = 0
    IndexTotalCount = "index_total_count"
    def index
        @indexParams = get_index_params()
        rqPageNum = @indexParams[:pageNum]
        @currentPage = rqPageNum.present? ? rqPageNum.to_i - 1 : 0
        @orderBy = @indexParams[:orderBy]
        @sort = @indexParams[:sort]
        @searchKey = @indexParams[:searchKey]
        @searchVal = @indexParams[:searchVal]
        @searchStartDate = @indexParams[:searchStartDate]
        @searchEndDate = @indexParams[:searchEndDate]
        hasSearchKeyAndVal = (@searchKey.present? && @searchVal.present?) || (@searchKey == "timestamp" && @searchStartDate.present? && @searchEndDate.present?)
        cacheKey = "index_page_search_key_#{hasSearchKeyAndVal ? @searchKey : nil}_search_val_#{@searchKey == "timestamp" ? "#{@searchStartDate}_#{@searchEndDate}" : (hasSearchKeyAndVal ? @searchVal : nil)}_#{@currentPage}_order_by_#{@orderBy.present? ? @orderBy : 'user_tracker_id'}_sort_#{@sort.present? ? @sort : 'ASC'}_"
        @cacheKey = cacheKey
        @data = MemCache.get(cacheKey)
        totalCountCacheKey = "#{cacheKey}_total_count"
        @totalCount = MemCache.get(totalCountCacheKey) || get_total_count(totalCountCacheKey)

        if !@data.present?
            @data = CustomerInfo.find_by_sql(sql_str())
            MemCache.set(cacheKey, @data)
        end
    end

    private
    def get_total_count(cacheKey)
        sql = sql_str("count")
        result = ActiveRecord::Base.connection.execute(sql)
        MemCache.set(cacheKey, result[0]["count"])
        return result[0]["count"]
    end

    def get_index_params
        params.permit(:pageNum, :orderBy, :sort, :searchKey, :searchVal, :searchStartDate, :searchEndDate)
    end

    def sql_str(type="")
        sql = "
            SELECT #{type == "count" ? "COUNT(user_tracker_id)" : "*"}
            FROM customer_infos AS ci
            WHERE
            (NOT EXISTS (
                SELECT * FROM customer_infos ci2
                WHERE
                CAST(ci2.timestamp AS DATE) = CAST(ci.timestamp AS DATE)
                and
                ci2.timestamp < ci.timestamp
                AND ci2.user_tracker_id = ci.user_tracker_id
            )
            OR NOT EXISTS (
                SELECT * from customer_infos ci3
                WHERE
                CAST(ci3.timestamp AS DATE) = CAST(ci.timestamp AS DATE)
                and
                ci3.timestamp > ci.timestamp
                AND ci3.user_tracker_id = ci.user_tracker_id
            )
            )
            #{@searchVal.present? && @searchKey.present? ? "AND #{@searchKey}='#{@searchVal}'" : ''}
            #{(@searchKey == "timestamp" && @searchStartDate.present? && @searchEndDate.present?) ? "AND timestamp between '#{@searchStartDate}' and '#{@searchEndDate}'" : ''}
            #{type == "count" ? "" : "ORDER BY #{@orderBy.present? ? @orderBy : 'user_tracker_id, ci.timestamp'} #{@sort.present? ? @sort : 'ASC'}
            LIMIT #{PerPageCount} OFFSET #{@currentPage.to_i * PerPageCount}"}
        "
    end

end
