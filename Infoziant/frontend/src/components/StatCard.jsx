export default function StatCard({ icon: Icon, value, label, colorClass = 'blue' }) {
  return (
    <div className={`stat-card ${colorClass}`}>
      <div className="stat-card-icon">
        <Icon size={32} strokeWidth={2} />
      </div>
      <div className="stat-card-value">{value}</div>
      <div className="stat-card-label">{label}</div>
    </div>
  )
}
