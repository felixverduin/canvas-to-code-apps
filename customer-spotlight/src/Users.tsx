import { useEffect, useState } from 'react'
import type { Systemusers } from './generated/models/SystemusersModel'

export default function Users() {
  const [users, setUsers] = useState<Systemusers[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')
  const [nextPage, setNextPage] = useState<string>()
  const [request, setRequest] = useState<{ skipToken?: string; revision: number }>({ revision: 0 })

  useEffect(() => {
    let cancelled = false

    async function loadUsers() {
      try {
        const { SystemusersService } = await import('./generated/services/SystemusersService')
        const result = await SystemusersService.getAll({
          select: ['systemuserid', 'fullname', 'internalemailaddress', 'domainname', 'jobtitle', 'isdisabled'],
          orderBy: ['fullname asc', 'systemuserid asc'],
          maxPageSize: 100,
          skipToken: request.skipToken,
        })
        if (!result.success || result.error) {
          throw new Error(result.error?.message || 'Dataverse could not retrieve users.')
        }
        if (cancelled) return
        setUsers((current) => request.skipToken ? [...current, ...(result.data ?? [])] : result.data ?? [])
        setNextPage(result.skipToken)
      } catch (cause) {
        if (!cancelled) setError(cause instanceof Error ? cause.message : 'An unexpected error occurred while loading users.')
      } finally {
        if (!cancelled) setLoading(false)
      }
    }

    void loadUsers()
    return () => { cancelled = true }
  }, [request])

  function refresh() {
    setLoading(true)
    setError('')
    setUsers([])
    setNextPage(undefined)
    setRequest((current) => ({ revision: current.revision + 1 }))
  }

  return (
    <section className="users-section" aria-labelledby="users-title" aria-busy={loading}>
      <div className="users-heading">
        <div><h2 id="users-title">Dataverse users</h2><p>Users from the systemuser table, including enabled and disabled accounts.</p></div>
        <button onClick={refresh} disabled={loading}>Refresh users</button>
      </div>
      <p role="status">{loading ? 'Loading users…' : `${users.length} users loaded${nextPage ? ' · More available' : ''}`}</p>
      {error && <div className="users-error" role="alert"><p>Could not load users: {error}</p><p>Open the app through Power Apps Local Play and check that you have permission to read the Users table.</p><button onClick={() => { setLoading(true); setError(''); setRequest((current) => ({ ...current, revision: current.revision + 1 })) }}>Try again</button></div>}
      {!loading && !error && users.length === 0 && <p>No users were returned by Dataverse.</p>}
      {users.length > 0 && <div className="users-table-wrapper"><table className="users-table"><thead><tr><th scope="col">Name</th><th scope="col">Email</th><th scope="col">Username</th><th scope="col">Job title</th><th scope="col">Status</th></tr></thead><tbody>{users.map((user) => <tr key={user.systemuserid}><th scope="row">{user.fullname || 'Unnamed user'}</th><td>{user.internalemailaddress || '—'}</td><td>{user.domainname || '—'}</td><td>{user.jobtitle || '—'}</td><td>{user.isdisabled === true ? 'Disabled' : user.isdisabled === false ? 'Enabled' : 'Unknown'}</td></tr>)}</tbody></table></div>}
      {nextPage && !error && <button className="load-more" disabled={loading} onClick={() => { setLoading(true); setError(''); setRequest((current) => ({ skipToken: nextPage, revision: current.revision + 1 })) }}>{loading ? 'Loading…' : 'Load more users'}</button>}
    </section>
  )
}
