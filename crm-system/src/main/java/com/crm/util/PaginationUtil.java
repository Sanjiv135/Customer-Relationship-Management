package com.crm.util;

public class PaginationUtil {
    
    public static int calculateOffset(int page, int pageSize) {
        return (page - 1) * pageSize;
    }
    
    public static int calculateTotalPages(int totalItems, int pageSize) {
        return (int) Math.ceil((double) totalItems / pageSize);
    }
    
    public static boolean isValidPage(int page, int totalPages) {
        return page >= 1 && page <= totalPages;
    }
}