'use client';

import { useState } from 'react';
import { useAuth } from '@/contexts/AuthContext';
import Footer from '@/components/layout/Footer';
import toast from 'react-hot-toast';
export default function LoginPage() {
  const { login } = useAuth();
  const [nomeUsuario, setNomeUsuario] = useState('');
  const [senha, setSenha] = useState('');
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    try {
      await login(nomeUsuario, senha);
      toast.success('Login realizado com sucesso!');
    } catch (err: any) {
      toast.error(
        err?.response?.data?.message || 'Credenciais inválidas',
      );
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex flex-col items-center justify-center bg-gradient-to-br from-primary-200 via-primary-100 to-pink-50">
      <div className="w-full max-w-md">
        <div className="bg-white rounded-2xl shadow-2xl p-8">
          <div className="flex flex-col items-center mb-8">
            <div className="-mb-9">
              <img src="/logo.png" alt="Duas Marias Doces" className="h-52 w-52 object-contain" />
            </div>
            <h1 className="font-dancing text-3xl text-primary-500 text-center">
              Seja bem vinda!
            </h1>
            <p className="text-sm text-gray-400 mt-1.5 tracking-wide">
              Faça login para continuar
            </p>
          </div>

          <form onSubmit={handleSubmit} className="space-y-4">
            <div>
              <label className="label-field">Usuário</label>
              <input
                type="text"
                className="input-field"
                placeholder="nome de usuário"
                value={nomeUsuario}
                onChange={(e) => setNomeUsuario(e.target.value)}
                required
                autoCapitalize="none"
                autoCorrect="off"
              />
            </div>
            <div>
              <label className="label-field">Senha</label>
              <input
                type="password"
                className="input-field"
                placeholder="********"
                value={senha}
                onChange={(e) => setSenha(e.target.value)}
                required
              />
            </div>
            <button
              type="submit"
              disabled={loading}
              className="btn-primary w-full flex items-center justify-center"
            >
              {loading ? (
                <div className="h-5 w-5 animate-spin rounded-full border-2 border-white border-t-transparent" />
              ) : (
                'Entrar'
              )}
            </button>
          </form>

          <div className="text-center mt-6">
            <Footer />
          </div>
        </div>
      </div>
    </div>
  );
}
