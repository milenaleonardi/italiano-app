# 🇮🇹 Italiano para Viagem

App completo para aprender italiano com vocabulário, diálogos, gramática, quiz e **chat com IA (Google Gemini)**. Progresso sincronizado entre todos os dispositivos via **Supabase**.

---

## 🏗️ Estrutura do projeto

```
italiano-app/
├── index.html              ← Frontend completo (SPA)
├── api/
│   ├── gemini.js           ← Proxy seguro para Google Gemini API
│   └── config.js           ← Expõe credenciais públicas do Supabase
├── supabase-schema.sql     ← Schema do banco de dados
├── vercel.json             ← Configuração do Vercel
└── .env.example            ← Exemplo de variáveis de ambiente
```

---

## 🚀 Setup completo (Vercel + Supabase + Gemini)

### Passo 1 — Criar projeto no Supabase

1. Acesse [supabase.com](https://supabase.com) → **New project**
2. Escolha um nome e senha para o banco
3. Aguarde o projeto inicializar (~1 min)
4. No menu lateral: **SQL Editor** → cole todo o conteúdo de `supabase-schema.sql` → **Run**
5. Anote as credenciais em **Settings → API**:
   - `Project URL` → será `SUPABASE_URL`
   - `anon / public key` → será `SUPABASE_ANON_KEY`

### Passo 2 — Configurar login com Google (OAuth)

1. No Supabase: **Authentication → Providers → Google → Enable**
2. No [Google Cloud Console](https://console.cloud.google.com):
   - Crie um projeto → **APIs & Services → Credentials → Create OAuth 2.0 Client**
   - Tipo: **Web application**
   - Authorized redirect URI: `https://SEU_PROJETO.supabase.co/auth/v1/callback`
   - Copie o **Client ID** e **Client Secret**
3. Cole o Client ID e Secret de volta no Supabase → **Save**

### Passo 3 — Obter chave do Google Gemini

1. Acesse [aistudio.google.com/app/apikey](https://aistudio.google.com/app/apikey)
2. Clique em **"Create API Key"**
3. Copie a chave gerada → será `GEMINI_API_KEY`

### Passo 4 — Deploy no Vercel

```bash
# Instale a CLI (se não tiver)
npm i -g vercel

# Na pasta do projeto
vercel
```

Ou via GitHub: [vercel.com](https://vercel.com) → **Add New Project** → importe o repositório.

### Passo 5 — Configurar variáveis de ambiente no Vercel

No dashboard do Vercel → seu projeto → **Settings → Environment Variables**:

| Nome | Onde obter |
|------|-----------|
| `GEMINI_API_KEY` | Google AI Studio |
| `SUPABASE_URL` | Supabase → Settings → API → Project URL |
| `SUPABASE_ANON_KEY` | Supabase → Settings → API → anon/public key |

Depois: **Deployments → ⋯ → Redeploy** para aplicar.

### Passo 6 — Configurar domínio no Supabase (para OAuth funcionar)

1. Supabase → **Authentication → URL Configuration**
2. **Site URL**: `https://seu-app.vercel.app`
3. **Redirect URLs**: adicione `https://seu-app.vercel.app`

---

## 💾 O que é sincronizado

| Dado | Tabela Supabase |
|------|----------------|
| Palavras favoritas | `user_progress.favorites` |
| Palavras estudadas | `user_progress.studied` |
| Erros no quiz | `user_progress.wrong` |
| Streak e dias visitados | `user_progress.streak / visit_days` |
| Histórico de quizzes | `user_progress.quiz_total` |
| Histórico de chat (por modo) | `chat_history` |
| Frases geradas pela IA | `generated_phrases` |

**Estratégia offline-first:**
- Todos os dados ficam no `localStorage` — o app funciona sem internet
- Ao fazer qualquer alteração, um upsert debounced (1.5s) é disparado para o Supabase
- Ao fazer login, os dados do Supabase são puxados e mesclados ao localStorage
- O botão "Sincronizar agora" força um sync manual

---

## 🔒 Segurança

- `GEMINI_API_KEY` — nunca exposta ao browser, fica só no servidor Vercel
- `SUPABASE_ANON_KEY` — chave pública segura. Row Level Security (RLS) garante que cada usuário acessa só os próprios dados
- Google OAuth — gerenciado pelo Supabase

---

## 🛠️ Desenvolvimento local

```bash
npm i -g vercel

# Crie .env.local com as 3 variáveis
cp .env.example .env.local
# Edite .env.local com seus valores reais

vercel dev  # http://localhost:3000
```
