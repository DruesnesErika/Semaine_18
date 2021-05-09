-- Créer une table commander_articles constituées de colonnes :

-- codart : id du produit
-- qte : quantité à commander
-- date : date du jour

CREATE TABLE commander_articles (
    codart INT NOT NULL,
    qte INT,
    datedecommande DATETIME
    ,CONSTRAINT commander_articles_PK PRIMARY KEY (codart)
);

-- Créer un déclencheur after_products_update sur la table products : lorsque le stock physique devient inférieur au stock d'alerte, une nouvelle ligne est insérée dans la table commander_articles.

-- Pour le jeu de test de votre déclencheur, on prendra le produit 8 (barbecue 'Athos') auquel on mettra pour valeur de départ :

-- pro_stock_alert = 5

DELIMITER |
CREATE TRIGGER after_products_update
AFTER UPDATE ON products
FOR EACH ROW
BEGIN
IF NEW.pro_stock < NEW.pro_stock_alert
THEN 
INSERT INTO commander_articles(codart, qte, datedecommande)
VALUES (NEW.pro_id, NEW.pro_stock_alert - NEW.pro_stock, NOW());
END IF ;
END |
DELIMITER ;