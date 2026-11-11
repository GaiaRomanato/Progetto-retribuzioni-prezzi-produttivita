# Estrazione equazioni OLS dal VAR
eq_esp  <- var_fit$varresult[["esportazioni"]]
eq_ven  <- var_fit$varresult[["vendite"]]
eq_prod <- var_fit$varresult[["prod_industriale"]]

# 1. Test direzionali Trivariati (linearHypothesis)
lh_esp_ven  <- linearHypothesis(eq_ven,  c("esportazioni.l1 = 0", "esportazioni.l2 = 0"))
lh_prod_ven <- linearHypothesis(eq_ven,  c("prod_industriale.l1 = 0", "prod_industriale.l2 = 0"))

lh_ven_esp  <- linearHypothesis(eq_esp,  c("vendite.l1 = 0", "vendite.l2 = 0"))
lh_prod_esp <- linearHypothesis(eq_esp,  c("prod_industriale.l1 = 0", "prod_industriale.l2 = 0"))

lh_esp_prod <- linearHypothesis(eq_prod, c("esportazioni.l1 = 0", "esportazioni.l2 = 0"))
lh_ven_prod <- linearHypothesis(eq_prod, c("vendite.l1 = 0", "vendite.l2 = 0"))

# 2. Test Bivariati (lmtest::grangertest)
gb_esp_ven  <- grangertest(vendite ~ esportazioni, order = 2, data = train_diff)
gb_ven_esp  <- grangertest(esportazioni ~ vendite, order = 2, data = train_diff)

gb_esp_prod <- grangertest(prod_industriale ~ esportazioni, order = 2, data = train_diff)
gb_prod_esp <- grangertest(esportazioni ~ prod_industriale, order = 2, data = train_diff)

gb_ven_prod <- grangertest(prod_industriale ~ vendite, order = 2, data = train_diff)
gb_prod_ven <- grangertest(vendite ~ prod_industriale, order = 2, data = train_diff)

# Estrazione dei valori F e p-value prendendo la seconda riga [2]
f_tri    <- c(lh_esp_ven$F[2], lh_ven_esp$F[2], lh_esp_prod$F[2], 
              lh_prod_esp$F[2], lh_ven_prod$F[2], lh_prod_ven$F[2])
p_tri    <- c(lh_esp_ven$`Pr(>F)`[2], lh_ven_esp$`Pr(>F)`[2], lh_esp_prod$`Pr(>F)`[2], 
              lh_prod_esp$`Pr(>F)`[2], lh_ven_prod$`Pr(>F)`[2], lh_prod_ven$`Pr(>F)`[2])

f_biv    <- c(gb_esp_ven$F[2], gb_ven_esp$F[2], gb_esp_prod$F[2], 
              gb_prod_esp$F[2], gb_ven_prod$F[2], gb_prod_ven$F[2])
p_biv    <- c(gb_esp_ven$`Pr(>F)`[2], gb_ven_esp$`Pr(>F)`[2], gb_esp_prod$`Pr(>F)`[2], 
              gb_prod_esp$`Pr(>F)`[2], gb_ven_prod$`Pr(>F)`[2], gb_prod_ven$`Pr(>F)`[2])

# Costruzione Tabella Comparativa
tab_compare <- data.frame(
  Direzione = c("Esportazioni -> Vendite", 
                "Vendite -> Esportazioni",
                "Esportazioni -> Prod. Ind.", 
                "Prod. Ind. -> Esportazioni",
                "Vendite -> Prod. Ind.", 
                "Prod. Ind. -> Vendite"),
  F_Tri     = round(f_tri, 3),
  pval_Tri  = round(p_tri, 4),
  Dec_Tri   = ifelse(p_tri < 0.05, "Rigetto H0", "Non rigetto"),
  F_Biv     = round(f_biv, 3),
  pval_Biv  = round(p_biv, 4),
  Dec_Biv   = ifelse(p_biv < 0.05, "Rigetto H0", "Non rigetto"),
  stringsAsFactors = FALSE
)

colnames(tab_compare) <- c("Direzione del Test", "F (Trivariato)", "p-val (Tri)", "Dec. (Tri)", "F (Bivariato)", "p-val (Biv)", "Dec. (Biv)")

kable(tab_compare, caption = "Confronto dei test direzionali di Granger: Sistema Trivariato vs Modelli Bivariati (lags = 2)", booktabs = TRUE) %>%
  kable_styling(latex_options = c("hold_position", "scale_down"))