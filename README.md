# comparador-ofertas-sql

Projeto feito 100% em SQL (MySQL) para ajudar quem quer aproveitar a Black Friday a **achar o melhor preço** de cada produto e **entender o desconto real** de cada oferta.

> **Aviso:** todos os dados (lojas, produtos e preços) são **fictícios**, criados apenas para estudo.

## O problema que o projeto resolve

Na Black Friday, o mesmo produto aparece com preços e descontos diferentes em cada loja. Este projeto organiza essas informações em um banco de dados e responde perguntas como:

- Qual loja tem o menor preço de cada produto?
- Quais são as ofertas com o maior percentual de desconto?
- Qual loja costuma dar mais desconto, em média?
- Quanto dinheiro eu economizo escolhendo a loja certa?

## Como rodar

1. Acesse o [OneCompiler (MySQL)](https://onecompiler.com/mysql).
2. Copie o conteúdo do arquivo `queries.sql` e cole no editor.
3. Clique em **Run**.

O script recria tudo do zero a cada execução (apaga e cria as views e tabelas novamente), então pode rodar quantas vezes quiser. Para ver o resultado de cada consulta, rode uma de cada vez (o editor mostra apenas a última).

Testado com MySQL 8.x.

## Estrutura do banco

| Objeto | Tipo | Descrição |
|---|---|---|
| `lojas` | tabela | Lojas participantes (id, nome) |
| `produtos` | tabela | Produtos e suas categorias (id, nome, categoria) |
| `precos` | tabela | Preço original e preço da Black Friday de cada produto em cada loja |
| `vw_ofertas` | view | Todas as ofertas, com o percentual de desconto já calculado |
| `vw_melhores_ofertas` | view | Apenas a melhor oferta (menor preço) de cada produto |

Relacionamentos: `precos.produto_id` aponta para `produtos.id` e `precos.loja_id` aponta para `lojas.id`.

## Consultas do projeto

| Consulta | O que responde | Conceitos usados |
|---|---|---|
| A | Todas as ofertas, da maior para a menor porcentagem de desconto | `VIEW`, `ORDER BY` |
| B | Menor preço de cada produto | `JOIN`, `GROUP BY`, `MIN` |
| C | Qual loja tem esse menor preço | `JOIN`, subconsulta |
| D | Quanto se economiza escolhendo a loja certa | `MIN`, `MAX`, `GROUP BY` |
| E | Melhores ofertas de uma categoria | `VIEW`, `WHERE` |
| F | Desconto médio por loja | `AVG`, `GROUP BY` |

## Exemplo de resultado

Consulta D (economia ao escolher a loja certa). Como os dados são fictícios, os valores são apenas ilustrativos:

| produto | menor_preco | maior_preco | economia |
|---|---|---|---|
| Notebook 15 polegadas | 2899.00 | 3199.00 | 300.00 |

!(<img width="503" height="316" alt="resultado-economia png" src="https://github.com/user-attachments/assets/f3f2f018-a846-417b-ba0c-e8eb79f2942d" />
)

## Próximos passos

- Criar uma tabela de **histórico de preços** para detectar descontos falsos (preço aumentado antes da promoção).
- Usar *window functions* (`LAG`, `RANK`) para ranquear ofertas e comparar variações de preço.
- Incluir cupons de desconto e frete na comparação.

## O que eu pratiquei

`CREATE TABLE`, chaves primárias e estrangeiras, `INSERT`, `JOIN` com várias tabelas, `GROUP BY`, funções de agregação (`MIN`, `MAX`, `AVG`), subconsultas e `VIEW`.
