# 🇮🇹 Italiano para Viagem

App completo para aprender italiano com vocabulário, diálogos, gramática, quiz e **chat com IA (Google Gemini)**. Progresso sincronizado em tempo real via **Supabase**.

🚀 **Acesse agora:** [https://italiano-app-six.vercel.app/](https://italiano-app-six.vercel.app/)

---

## 🏗️ Estrutura do projeto

```
italiano-app/
├── index.html              ← Frontend completo (SPA)
├── api/
│   ├── gemini.js           ← Proxy seguro para Google Gemini API
│   └── config.js           ← Expõe credenciais públicas do Supabase
├── supabase-schema.sql     ← Schema do banco de dados (SQL)
├── vercel.json             ← Configuração de deploy (Vercel)
└── .env.example            ← Exemplo de variáveis de ambiente
```

---

## 🚀 Configuração Rápida

### 1. Banco de Dados (Supabase)
1. Crie um projeto no [Supabase](https://supabase.com).
2. No **SQL Editor**, execute o conteúdo de `supabase-schema.sql`.
3. Em **Settings → API**, pegue a `Project URL` e a `anon/public key`.

### 2. Autenticação Google (OAuth)
1. No [Google Cloud Console](https://console.cloud.google.com), crie um **ID do cliente OAuth 2.0** (Web application).
2. Adicione a **Callback URL** fornecida pelo Supabase (**Authentication → Providers → Google**) nos URIs de redirecionamento autorizados do Google.
3. Insira o Client ID e Client Secret no dashboard do Supabase e salve.
4. Em **Authentication → URL Configuration**, adicione a URL do Vercel em **Site URL** e **Redirect URLs**.

### 3. IA (Google Gemini)
1. Obtenha sua chave de API em [Google AI Studio](https://aistudio.google.com/app/apikey).

### 4. Deploy (Vercel)
Configure as seguintes variáveis de ambiente no Vercel:

| Variável | Descrição |
|----------|-----------|
| `GEMINI_API_KEY` | Sua chave do Google Gemini |
| `SUPABASE_URL` | URL do seu projeto Supabase |
| `SUPABASE_ANON_KEY` | Chave anônima do Supabase |

---

## 💾 Recursos e Sincronização

O app utiliza uma estratégia **offline-first**:
- **Persistência Local:** Dados salvos no `localStorage` para funcionamento instantâneo.
- **Sincronização Cloud:** Backup automático para o Supabase (favoritos, progresso, histórico de chat e frases geradas).
- **Multi-dispositivo:** Acesse seu progresso de qualquer lugar fazendo login.

---

## 🛠️ Desenvolvimento Local

```bash
# Instale a Vercel CLI
npm i -g vercel

# Configure o ambiente
cp .env.example .env.local

# Inicie o servidor de desenvolvimento
vercel dev
```

---

## 🔒 Segurança
- **API Keys:** A chave do Gemini é processada apenas no lado do servidor (Vercel Functions).
- **RLS:** O Supabase utiliza *Row Level Security* para garantir que cada usuário só acesse seus próprios dados.
