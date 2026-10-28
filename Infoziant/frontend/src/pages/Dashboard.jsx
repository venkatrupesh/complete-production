import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import { getDashboardStats } from '../services/api'
import { Car, FileText, Clock, AlertCircle, Plus } from 'lucide-react'
import StatCard from '../components/StatCard'
import Alert from '../components/Alert'

function formatDate(dateStr) {
  if (!dateStr) return '—'
  return new Date(dateStr).toLocaleDateString('en-IN', {
    day: '2-digit', month: 'short', year: 'numeric'
  })
}

function formatBytes(bytes) {
  if (!bytes) return '—'
  if (bytes < 1024) return `${bytes} B`
  if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(1)} KB`
  return `${(bytes / (1024 * 1024)).toFixed(1)} MB`
}

export default function Dashboard() {
  const [data, setData] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)
  const navigate = useNavigate()

  useEffect(() => {
    getDashboardStats()
      .then(setData)
      .catch(e => setError(e.message))
      .finally(() => setLoading(false))
  }, [])

  if (loading) {
    return (
      <div className="loading-center">
        <div className="spinner" />
        <p>Loading dashboard…</p>
      </div>
    )
  }

  if (error) {
    return (
      <div>
        <div className="page-header">
          <h1>Dashboard</h1>
        </div>
        <Alert type="error">{error}</Alert>
      </div>
    )
  }

  const { stats, recentVehicles, recentDocuments } = data

  return (
    <div>
      <div className="page-accent-line" />
      <div className="page-header">
        <h1>
          Welcome to <span className="gradient-text">VehicleVault</span>
        </h1>
        <p>Your vehicle document management command centre</p>
      </div>

      {/* Stats */}
      <div className="stats-grid">
        <StatCard icon={Car} value={stats.totalVehicles} label="Registered Vehicles" colorClass="blue" />
        <StatCard icon={FileText} value={stats.totalDocuments} label="Uploaded Documents" colorClass="purple" />
        <StatCard icon={Clock} value={stats.expiringDocuments} label="Expiring in 30 Days" colorClass="warning" />
        <StatCard icon={AlertCircle} value={stats.expiredDocuments} label="Expired Documents" colorClass="danger" />
      </div>

      {/* Recent sections */}
      <div className="dashboard-grid">
        {/* Recent Vehicles */}
        <div className="card">
          <div className="card-title">Recently Added Vehicles</div>
          {recentVehicles.length === 0 ? (
            <div className="empty-state" style={{ padding: 'var(--spacing-8)' }}>
              <div className="empty-state-icon">
                <Car size={64} strokeWidth={1.5} />
              </div>
              <h3>No vehicles yet</h3>
              <p>Add your first vehicle to get started.</p>
              <button className="btn btn-primary btn-sm" onClick={() => navigate('/vehicles')}>
                <Plus size={16} /> Add Vehicle
              </button>
            </div>
          ) : (
            <div className="recent-list">
              {recentVehicles.map(v => (
                <div key={v._id} className="recent-item">
                  <div className="recent-item-icon vehicle">
                    <Car size={20} strokeWidth={2} />
                  </div>
                  <div className="recent-item-info">
                    <div className="recent-item-title">{v.registrationNumber}</div>
                    <div className="recent-item-sub">{v.make} {v.model} · {v.year}</div>
                  </div>
                  <span className="badge badge-info">{formatDate(v.createdAt)}</span>
                </div>
              ))}
            </div>
          )}
        </div>

        {/* Recent Documents */}
        <div className="card">
          <div className="card-title">Recently Uploaded Documents</div>
          {recentDocuments.length === 0 ? (
            <div className="empty-state" style={{ padding: 'var(--spacing-8)' }}>
              <div className="empty-state-icon">
                <FileText size={64} strokeWidth={1.5} />
              </div>
              <h3>No documents yet</h3>
              <p>Upload your first PDF document to get started.</p>
              <button className="btn btn-primary btn-sm" onClick={() => navigate('/documents')}>
                <Plus size={16} /> Upload Document
              </button>
            </div>
          ) : (
            <div className="recent-list">
              {recentDocuments.map(d => (
                <div key={d._id} className="recent-item">
                  <div className="recent-item-icon document">
                    <FileText size={20} strokeWidth={2} />
                  </div>
                  <div className="recent-item-info">
                    <div className="recent-item-title">{d.title}</div>
                    <div className="recent-item-sub">
                      {d.vehicle?.registrationNumber} · {d.documentType} · {formatBytes(d.fileSize)}
                    </div>
                  </div>
                  {d.expiryDate && (
                    <span className={`badge ${new Date(d.expiryDate) < new Date() ? 'badge-danger' : 'badge-warning'}`}>
                      {formatDate(d.expiryDate)}
                    </span>
                  )}
                </div>
              ))}
            </div>
          )}
        </div>
      </div>

      {/* Security notice */}
      <div style={{ marginTop: 'var(--spacing-8)' }}>
        <Alert type="warning">
          <strong>Security Note:</strong> This application is an unauthenticated MVP for demonstration. 
          Do not expose it to the public internet without adding authentication and additional security controls.
        </Alert>
      </div>
    </div>
  )
}
