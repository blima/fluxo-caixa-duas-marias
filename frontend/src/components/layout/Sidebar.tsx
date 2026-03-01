'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { useLoja } from '@/contexts/LojaContext';
import {
  HomeIcon,
  BanknotesIcon,
  DocumentTextIcon,
  TagIcon,
  MapPinIcon,
  FlagIcon,
  CreditCardIcon,
  UsersIcon,
  BuildingStorefrontIcon,
  XMarkIcon,
} from '@heroicons/react/24/outline';

type NavLink = { name: string; href: string; icon: React.ForwardRefExoticComponent<any> };
type NavGroup = { name: string; children: NavLink[] };
type NavItem = NavLink | NavGroup;

const navigation: NavItem[] = [
  { name: 'Dashboard', href: '/dashboard', icon: HomeIcon },
  { name: 'Lançamentos', href: '/lancamentos', icon: BanknotesIcon },
  { name: 'Extrato', href: '/extrato', icon: DocumentTextIcon },
  {
    name: 'Cadastros',
    children: [
      { name: 'Lojas', href: '/cadastros/lojas', icon: BuildingStorefrontIcon },
      { name: 'Origens', href: '/cadastros/origens', icon: MapPinIcon },
      { name: 'Destinos', href: '/cadastros/destinos', icon: FlagIcon },
      { name: 'Etiquetas', href: '/cadastros/etiquetas', icon: TagIcon },
      { name: 'Tipos de Pagamento', href: '/cadastros/tipos-pagamento', icon: CreditCardIcon },
      { name: 'Usuários', href: '/cadastros/usuarios', icon: UsersIcon },
    ],
  },
];

interface SidebarProps {
  open: boolean;
  onClose: () => void;
}

export default function Sidebar({ open, onClose }: SidebarProps) {
  const pathname = usePathname();
  const { lojas, lojaId, setLojaId } = useLoja();

  return (
    <>
      {/* Overlay mobile */}
      {open && (
        <div
          className="fixed inset-0 z-40 bg-black/40 lg:hidden"
          onClick={onClose}
        />
      )}

      <aside
        className={`fixed left-0 top-0 z-50 h-screen w-64 bg-primary-50 border-r border-primary-100 text-gray-700 flex flex-col transition-transform duration-200 lg:translate-x-0 ${
          open ? 'translate-x-0' : '-translate-x-full'
        }`}
      >
        <div className="border-b border-primary-100">
          <div className="flex items-center justify-between px-4 pt-3 pb-3">
            <div className="flex items-center gap-3 flex-1 min-w-0">
              <img src="/logo.png" alt="Duas Marias Doces" className="h-12 w-12 flex-shrink-0 object-contain" />
              <img src="/logoNome.png" alt="Duas Marias Doces" className="h-10 object-contain" />
            </div>
            <button onClick={onClose} className="lg:hidden text-gray-400 hover:text-gray-600 ml-2">
              <XMarkIcon className="h-6 w-6" />
            </button>
          </div>
        </div>

        {/* Seletor de Loja */}
        {lojas.length > 0 && (
          <div className="px-3 py-3 border-b border-primary-100">
            <div className="flex items-center gap-2 px-1 mb-1.5">
              <BuildingStorefrontIcon className="h-4 w-4 text-primary-400" />
              <span className="text-[11px] font-semibold text-primary-400 uppercase tracking-wider">Loja</span>
            </div>
            <select
              value={lojaId}
              onChange={(e) => setLojaId(e.target.value)}
              className="w-full bg-white text-gray-700 text-sm rounded-lg px-3 py-2 border border-primary-200 focus:outline-none focus:ring-2 focus:ring-primary-300 cursor-pointer"
            >
              {lojas.map((l) => (
                <option key={l.id} value={l.id}>{l.nome}{l.matriz ? ' (Matriz)' : ''}</option>
              ))}
            </select>
          </div>
        )}

        <nav className="flex-1 overflow-y-auto py-4 px-3">
          {navigation.map((item) => {
            if ('href' in item) {
              const link = item as NavLink;
              const active = pathname === link.href;
              const Icon = link.icon;
              return (
                <Link
                  key={link.name}
                  href={link.href}
                  onClick={onClose}
                  className={`flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-medium transition-colors mb-1 ${
                    active
                      ? 'bg-primary-500 text-white shadow-sm'
                      : 'text-gray-600 hover:bg-primary-100 hover:text-primary-700'
                  }`}
                >
                  <Icon className="h-5 w-5" />
                  {link.name}
                </Link>
              );
            }

            const group = item as NavGroup;
            return (
              <div key={group.name} className="mb-2">
                <p className="px-3 py-2 text-xs font-semibold text-primary-400 uppercase tracking-wider">
                  {group.name}
                </p>
                {group.children.map((child) => {
                  const active = pathname === child.href;
                  const ChildIcon = child.icon;
                  return (
                    <Link
                      key={child.name}
                      href={child.href}
                      onClick={onClose}
                      className={`flex items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium transition-colors mb-0.5 ${
                        active
                          ? 'bg-primary-500 text-white shadow-sm'
                          : 'text-gray-600 hover:bg-primary-100 hover:text-primary-700'
                      }`}
                    >
                      <ChildIcon className="h-5 w-5" />
                      {child.name}
                    </Link>
                  );
                })}
              </div>
            );
          })}
        </nav>
      </aside>
    </>
  );
}
