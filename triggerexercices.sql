-- Mettez en place ce trigger, puis ajoutez un produit dans une commande, vérifiez que le champ total est bien mis à jour.

DELIMITER |
CREATE TRIGGER maj_total 
AFTER INSERT ON lignedecommande
FOR EACH ROW
BEGIN
    DECLARE id_c INT;
    DECLARE tot DOUBLE;
    SET id_c = NEW.id_commande; -- nous captons le numéro de commande concerné
    SET tot = (SELECT sum(prix*quantite) FROM lignedecommande WHERE id_commande=id_c); -- on recalcul le total
    UPDATE commande SET total=tot WHERE id=id_c; -- on stock le total dans la table commande
END |
DELIMITER ;


INSERT INTO 'lignedecommande'('id_commande', 'id_produit', 'quantite', 'prix')
VALUES ('1', '1', '1', '10.00');
 

--  Ce trigger ne fonctionne que lorsque l'on ajoute des produits, les modifications ou suppressions ne permettent pas de recalculer le total. Comment pourrait-on faire ?

 DELIMITER |
CREATE TRIGGER insert_maj_total 
AFTER INSERT ON lignedecommande
FOR EACH ROW
BEGIN
    DECLARE id_c INT;
    DECLARE tot DOUBLE;
    SET id_c = NEW.id_commande; -- nous captons le numéro de commande concerné
    SET tot = (SELECT sum(prix*quantite) FROM lignedecommande WHERE id_commande=id_c); -- on recalcul le total
    UPDATE commande SET total=tot WHERE id=id_c; -- on stock le total dans la table commande
END |
DELIMITER ;


 DELIMITER |
CREATE TRIGGER update_maj_total 
AFTER UPDATE ON lignedecommande
FOR EACH ROW
BEGIN
    DECLARE id_c INT;
    DECLARE tot DOUBLE;
    SET id_c = NEW.id_commande; -- nous captons le numéro de commande concerné
    SET tot = (SELECT sum(prix*quantite) FROM lignedecommande WHERE id_commande=id_c); -- on recalcul le total
    UPDATE commande SET total=tot WHERE id=id_c; -- on stock le total dans la table commande
END |
DELIMITER ;



 DELIMITER |
CREATE TRIGGER delete_maj_total 
AFTER DELETE ON lignedecommande
FOR EACH ROW
BEGIN
    DECLARE id_c INT;
    DECLARE tot DOUBLE;
    SET id_c = OLD.id_commande; -- nous captons le numéro de commande concerné
    SET tot = (SELECT sum(prix*quantite) FROM lignedecommande WHERE id_commande=id_c); -- on recalcul le total
    UPDATE commande SET total=tot WHERE id=id_c; -- on stock le total dans la table commande
END |
DELIMITER ;


-- Un champ remise était prévu dans la table commande. Comment pourrait-on le prendre en compte ?


DELIMITER |
CREATE TRIGGER maj_total 
AFTER INSERT ON lignedecommande
FOR EACH ROW
BEGIN
    DECLARE id_c INT;
    DECLARE tot DOUBLE;
    SET id_c = NEW.id_commande; -- nous captons le numéro de commande concerné
    SET tot = (SELECT sum((prix*remise/100)*quantite) FROM lignedecommande WHERE id_commande=id_c); -- on recalcul le total
    UPDATE commande SET total=tot WHERE id=id_c; -- on stock le total dans la table commande
END |
DELIMITER ;
