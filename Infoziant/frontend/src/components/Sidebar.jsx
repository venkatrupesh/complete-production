import { NavLink } from 'react-router-dom'
import { LayoutDashboard, Car, FileText, Activity, Truck } from 'lucide-react'

const navItems = [
  { to: '/dashboard', icon: LayoutDashboard, label: 'Dashboard' },
  { to: '/vehicles',  icon: Car, label: 'Vehicles' },
  { to: '/documents', icon: FileText, label: 'Documents' },
  { to: '/status',    icon: Activity, label: 'System Status' },
]

export default function Sidebar() {
  return (
    <aside className="sidebar">
      <div className="sidebar-logo">
        <div className="sidebar-logo-icon">
          <Truck size={24} strokeWidth={2.5} />
        </div>
        <div className="sidebar-logo-text">
          <span className="sidebar-logo-title">VehicleVault</span>
          <span className="sidebar-logo-sub">Document Manager</span>
        </div>
      </div>

      <nav className="sidebar-nav">
        <span className="sidebar-section-label">Navigation</span>
        {navItems.map(({ to, icon: Icon, label }) => (
          <NavLink
            key={to}
            to={to}
            className={({ isActive }) =>
              `sidebar-link${isActive ? ' active' : ''}`
            }
          >
            <span className="sidebar-link-icon">
              <Icon size={18} strokeWidth={2} />
            </span>
            {label}
          </NavLink>
        ))}
      </nav>

      <div className="sidebar-footer">
        <p>VehicleVault v1.0</p>
        <p>MERN + Docker</p>
      </div>
    </aside>
  )
}
