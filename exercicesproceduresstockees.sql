-- Exercice 1 : création d'une procédure stockée sans paramètre
-- Créez la procédure stockée Lst_Suppliers correspondant à la requête afficher le nom des fournisseurs pour lesquels une commande a été passée.

DELIMITER |

CREATE PROCEDURE Lst_Suppliers()
BEGIN
    SELECT DISTINCT sup_name, sup_city, sup_countries_id, sup_zipcode, sup_contact, sup_phone, sup_mail
    FROM suppliers, products, orders_details
    WHERE suppliers.sup_id = products.pro_sup_id
    AND pro_id IN
    (SELECT ode_pro_id FROM orders_details, products WHERE products.pro_id = orders_details.ode_pro_id);
END |

DELIMITER ;

-- Exécutez la commande SQL suivante pour obtenir des informations sur cette procédure stockée :

SHOW CREATE PROCEDURE Lst_Suppliers;


-- Exercice 2 : création d'une procédure stockée avec un paramètre en entrée

-- Créer la procédure stockée Lst_Rush_Orders, qui liste les commandes ayant le libelle "commande urgente".

DELIMITER |

CREATE PROCEDURE Lst_Rush_Orders()
BEGIN 
    SELECT ord_id, ord_order_date, ord_payment_date, ord_ship_date, ord_reception_date, ord_status, ord_cus_id
    FROM orders 
    WHERE ord_status = "Commande urgente";
END |

DELIMITER ;


-- Exercice 3 : création d'une procédure stockée avec plusieurs paramètres
-- Créer la procédure stockée CA_Supplier, qui pour un code fournisseur et une année entrée en paramètre, calcule et restitue le CA potentiel de ce fournisseur pour l'année souhaitée.

-- On exécutera la requête que si le code fournisseur est valide, c'est-à-dire dans la table suppliers.

DELIMITER |

CREATE PROCEDURE CA_Supplier(IN p_code_four VARCHAR(50),
                             IN p_annee INT(4)
                             )
BEGIN
   

    SELECT sup_name, ROUND(SUM((ode_unit_price-(ode_unit_price*ode_discount/100))* ode_quantity),2) AS "Chiffre d'affaires"
    FROM  orders
    JOIN orders_details ON ode_ord_id = ord_id
    JOIN suppliers ON sup_id = p_code_four
    WHERE orders.ord_order_date LIKE CONCAT(p_annee, "%")
    GROUP BY sup_name;
END |

DELIMITER ;

-- Testez cette procédure avec différentes valeurs des paramètres.
