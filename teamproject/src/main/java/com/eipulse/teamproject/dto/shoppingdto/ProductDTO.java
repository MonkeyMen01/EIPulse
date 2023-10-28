package com.eipulse.teamproject.dto.shoppingdto;


import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ProductDTO {
    private Integer id;
    private String productName;
    private Integer subTypeId;
    private String description;
    private Integer price;
    private Integer stockQuantity;
    private String imageUrl;
    private String status;

    public ProductDTO() {
    }

    public ProductDTO(String productName, Integer subTypeId, String description, Integer price, Integer stockQuantity, String imageUrl) {
        this.productName = productName;
        this.subTypeId = subTypeId;
        this.description = description;
        this.price = price;
        this.stockQuantity = stockQuantity;
        this.imageUrl = imageUrl;
    }

    public ProductDTO(Integer id, String productName, Integer subTypeId, String description, Integer price, Integer stockQuantity, String imageUrl) {
        this.id = id;
        this.productName = productName;
        this.subTypeId = subTypeId;
        this.description = description;
        this.price = price;
        this.stockQuantity = stockQuantity;
        this.imageUrl = imageUrl;
    }

    public ProductDTO(Integer id, String productName, String description, Integer price, Integer stockQuantity, String imageUrl) {
        this.id = id;
        this.productName = productName;
        this.description = description;
        this.price = price;
        this.stockQuantity = stockQuantity;
        this.imageUrl = imageUrl;
    }

    public ProductDTO(String productName, Integer subTypeId, String description, Integer price, Integer stockQuantity, String imageUrl, String status) {
        this.productName = productName;
        this.subTypeId = subTypeId;
        this.description = description;
        this.price = price;
        this.stockQuantity = stockQuantity;
        this.imageUrl = imageUrl;
        this.status = status;
    }

    public ProductDTO(Integer id, String productName, Integer subTypeId, String description, Integer price, Integer stockQuantity, String imageUrl, String status) {
        this.id = id;
        this.productName = productName;
        this.subTypeId = subTypeId;
        this.description = description;
        this.price = price;
        this.stockQuantity = stockQuantity;
        this.imageUrl = imageUrl;
        this.status = status;
    }

    public ProductDTO(Integer id) {
        this.id = id;
    }
}
