# frozen_string_literal: true

describe Admin::SlotsController, type: :controller do
  let(:organisation) { create(:organisation) }

  describe "#index" do
    it "assigns search_result" do
      now = Time.zone.parse("2021-11-17 11h40")
      travel_to(now)
      agent = create(:agent, :secretaire, basic_role_in_organisations: [organisation])
      motif = create(:motif, organisation: organisation)
      from_date = Date.new(2021, 11, 23)
      agent_ids = []
      lieu = create(:lieu, organisation: organisation)

      create(:plage_ouverture, first_day: from_date, start_time: Tod::TimeOfDay(9), end_time: Tod::TimeOfDay(11), organisation: organisation, motifs: [motif], agent: agent, lieu: lieu)

      sign_in agent

      get :index, params: {
        organisation_id: organisation.id,
        service_id: agent.service_id,
        motif_id: motif.id,
        from_date: from_date,
        agent_ids: agent_ids,
        lieu_id: lieu
      }

      expect(assigns(:search_results)).not_to be_nil
    end
  end
end
