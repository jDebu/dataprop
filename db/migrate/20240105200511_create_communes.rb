require 'csv'

class CreateCommunes < ActiveRecord::Migration[7.1]
  def change
    create_table :communes do |t|
      t.string :name

      t.timestamps
    end

    import_communes_from_csv('db/data/comunas.csv')
  end

  private

  def import_communes_from_csv(file_path)
    csv_text = File.read(file_path)
    csv = CSV.parse(csv_text, headers: true, col_sep: ',')

    communes_data = csv.map do |row|
      {
        id: row['id'].to_i,
        name: row['name']
      }
    end

    Commune.insert_all(communes_data)
  end
end
