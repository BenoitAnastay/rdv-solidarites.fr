# frozen_string_literal: true

class AddLogementAndNoteToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :logement, :integer
    add_column :users, :notes, :text

    UserProfile.find_each do |profile|
      user = profile.user
      # On part du principe que le logement est identique pour toutes et tous normalement
      # Il y a 34 usagers qui ont 2 profiles avec des valeurs différentes sur le logement
      #
      # ```
      # irb(main):021:0> User.joins(:user_profiles).group(:id).having("count(user_profiles.id) > 1").select {|u| u.user_profiles.pluck(:logement).uniq.compact.count > 1}.count
      # => 34
      # ```
      #
      # Ces profiles sont sur 3 départements
      #
      # ```
      # irb(main):023:0> User.joins(:user_profiles).group(:id).having("count(user_profiles.id) > 1").select {|u| u.user_profiles.pluck(:logement).uniq.compact.count > 1}.flat_map(&:organisations).uniq.flat_map(&:territo
      # ry).flat_map(&:name).uniq
      # => ["Pas-de-Calais", "Pyrénées-Atlantiques", "Seine-et-Marne"]
      # ```
      # Le Pas-de-Calais et les Pyrénées-Atlantique n'ont pas activé l'utilisation du logement.
      #
      # Je viens d'envoyer un message à la Seine-et-Marne. Attendons leur retour pour finaliser la migration
      #
      new_notes = user.notes || ""
      new_notes << profile.notes if profile.notes.present?
      user.update(logement: profile.logement, notes: new_notes)
    end
  end
end
