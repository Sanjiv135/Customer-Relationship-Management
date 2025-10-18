package com.crm.dao;

import com.crm.model.Product;
import com.crm.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    
    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Product product = new Product();
                product.setId(rs.getInt("id"));
                product.setName(rs.getString("name"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getDouble("price"));
                product.setCategory(rs.getString("category"));
                product.setStockQuantity(rs.getInt("stock_quantity"));
                product.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                products.add(product);
            }

        } catch (SQLException e) {
            System.out.println("Error getting all products: " + e.getMessage());
        }

        return products;
    }

    
    public boolean addProduct(Product product) {
        String sql = "INSERT INTO products (name, description, price, category, stock_quantity) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, product.getName());
            stmt.setString(2, product.getDescription());
            stmt.setDouble(3, product.getPrice());
            stmt.setString(4, product.getCategory());
            stmt.setInt(5, product.getStockQuantity());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("Error adding product: " + e.getMessage());
            return false;
        }
    }

    
    public boolean updateProduct(Product product) {
        String sql = "UPDATE products SET name = ?, description = ?, price = ?, category = ?, stock_quantity = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, product.getName());
            stmt.setString(2, product.getDescription());
            stmt.setDouble(3, product.getPrice());
            stmt.setString(4, product.getCategory());
            stmt.setInt(5, product.getStockQuantity());
            stmt.setInt(6, product.getId());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("Error updating product: " + e.getMessage());
            return false;
        }
    }

    
    public boolean deleteProduct(int id) {
        String sql = "DELETE FROM products WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("Error deleting product: " + e.getMessage());
            return false;
        }
    }

    
    public Product getProductById(int id) {
        Product product = null;
        String sql = "SELECT * FROM products WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                product = new Product();
                product.setId(rs.getInt("id"));
                product.setName(rs.getString("name"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getDouble("price"));
                product.setCategory(rs.getString("category"));
                product.setStockQuantity(rs.getInt("stock_quantity"));
                product.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
            }

        } catch (SQLException e) {
            System.out.println("Error getting product by ID: " + e.getMessage());
        }

        return product;
    }
}
