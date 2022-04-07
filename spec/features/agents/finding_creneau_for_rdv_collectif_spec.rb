# frozen_string_literal: true

describe "Agent can find a creneau for a rdv collectif", js: true do
  let(:agent) { create(:agent, basic_role_in_organisations: [organisation], service: service) }
  let!(:motif) do
    create(:motif, :collectif, name: "Atelier participatif", organisation: organisation, service: service)
  end
  let(:organisation) { create(:organisation) }
  let!(:service) { create(:service) }
  let!(:lieu) { create(:lieu, organisation: organisation) }
  let!(:rdv) do
    create(:rdv, motif: motif, organisation: organisation, agents: [agent], max_participants_count: 5)
  end

  specify do
    login_as(agent, scope: :agent)

    # Creating a new RDV Collectif
    visit admin_organisation_agent_agenda_path(organisation, agent)
    click_link "Trouver un RDV"

    select "Atelier participatif", from: "Motif"
    click_button "Afficher les créneaux"

    # The rdv collectif appears in the search results
    expect(page).to have_content("Résultats de votre recherche")
    expect(page).to have_content("1 participant")
    expect(page).to have_content("4 places disponibles")

    click_link "Ajouter un participant"

    expect(page).to have_current_path(edit_admin_organisation_rdvs_collectif_path(rdv.organisation, rdv))
  end
end
