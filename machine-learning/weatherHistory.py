#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Mar 25 10:09:37 2020

@author: m04m_br
"""
## Importação do csv para dataframe
import pandas as pd
base = pd.read_csv('weatherHistory.csv')

## Correção de valores NaN (Excluindo dados faltantes)
base.loc[pd.isnull(base['Precip Type'])]
base2 = base.dropna()

## Criando dataframe para classe e previsores
previsores = base2.iloc[:, 3:11].values
classe = base2.iloc[:, 2].values

## Pré-processamento Escalonamento
from sklearn.preprocessing import StandardScaler
scaler = StandardScaler()
previsores = scaler.fit_transform(previsores)

## Divisão dos dados por dataframe de treino e teste
from sklearn.model_selection import train_test_split
previsores_treinamento, previsores_teste, classe_treinamento, classe_teste = train_test_split(previsores, classe, test_size=0.15, random_state=0)

## Treino
from sklearn.naive_bayes import GaussianNB
classificador = GaussianNB()
classificador.fit(previsores_treinamento, classe_treinamento)

## Teste
previsoes = classificador.predict(previsores_teste)

## Precisão e Matriz de Comparação
from sklearn.metrics import confusion_matrix, accuracy_score
precisao = accuracy_score(classe_teste, previsoes)
matriz = confusion_matrix(classe_teste, previsoes)
