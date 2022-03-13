# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
careers = [
  "Data scientist",
  "Software tester",
  "Systems analyst",
  "Software business analyst",
  "Product manager",
  "Network architect",
  "Software engineer",
  "Software developer",
  "Full-stack web developer",
  "Front-end web developer",
  "Back-end web developer",
  "Engineering manager",
  "User interface designer",
  "Database administrator",
  "Cloud computing engineer",
  "DevOps Engineer",
  "Information security analyst",
  "Computer science professor",
  "Information security",
  "Software quality assurance",
  "Information technology specialist",
  "Mobile application designer or developer",
  "Research and development (R&D) scientist",
  "Computer scientist or computer science researcher",
  "Artificial intelligence and machine learning engineer",
  "Security Engineer",
  "Cybersecurity",
  "Multimedia programmer",
  "Games developer",
  "Technical writer",
  "information systems manager",
  "IT consultant ",
  "Applications architect",
  "Desktop Developer",
  "Mobile developer",
  "Big Data Developer",
  "Embedded Developer"
].sort

careers.each do |career|
  Career.create!(:field => career)
end