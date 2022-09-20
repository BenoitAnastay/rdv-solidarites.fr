# frozen_string_literal: true

describe "CNFS agent can configure online booking" do
  let!(:organisation) { create(:organisation) }
  let!(:agent) { create(:agent, :cnfs, admin_role_in_organisations: [organisation]) }

  before do
    login_as(agent, scope: :agent)
    visit authenticated_agent_root_path
    click_link "Paramètres"
    click_link "Réservation en ligne"
  end

  context "when there is no bookable motifs" do
    it "can't copy the shareable link", js: true do
      expect(page).to have_css('[data-clipboard-target="copy-button"][disabled]')
    end
  end

  context "when there is a bookable motif" do
    let!(:motif) { create(:motif, organisation: organisation, service: agent.service, reservable_online: true) }

    context "when there is no related plage d'ouverture" do
      it "can't copy the shareable link", js: true do
        expect(page).to have_css('[data-clipboard-target="copy-button"][disabled]')
      end
    end

    context "when there is a related plage d'ouverture" do
      before { motif.plage_ouvertures << create(:plage_ouverture, organisation: organisation, agent: agent) }

      it "can copy the shareable link", js: true do
        expect(page).not_to have_css('[data-clipboard-target="copy-button"][disabled]')
        accept_alert do
          click_button "copier"
          expect(page.driver.browser.switch_to.alert.text).to eq("Lien copié dans le presse-papiers !")
        end
      end
    end
  end
end
