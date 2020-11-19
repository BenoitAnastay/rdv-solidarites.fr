class Agent::RdvPolicy < DefaultAgentPolicy
  def status?
    same_agent_or_has_access?
  end

  class Scope < Scope
    def resolve
      if @context.agent.can_access_others_planning?
        scope.where(organisation_id: @context.organisation.id)
      else
        scope.joins(:motif).where(organisation_id: @context.organisation.id, motifs: { service_id: @context.agent.service_id })
      end
    end
  end
end
