# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movies.first)

# ============================================================================
# SEED CAREERS
# ============================================================================
MAX_USER_CAREERS = 3

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

puts "Seeding careers..."
careers.each do |career|
  Career.find_or_create_by!(field: career)
end
puts "Careers created: #{Career.count}"

# ============================================================================
# SEED SAMPLE USERS (skip if users already exist)
# ============================================================================
puts "\nSeeding sample users..."
users_data = [
  {
    email: "alice@example.com",
    username: "alice_dev",
    firstname: "Alice",
    lastname: "Johnson",
    password: "SecurePass123!",
    bio: "Full-stack developer passionate about clean code and user experience",
    about: "Senior developer with 8 years of experience in web technologies",
    career_fields: ["Full-stack web developer", "Software engineer", "Front-end web developer"]
  },
  {
    email: "bob@example.com",
    username: "bob_data",
    firstname: "Bob",
    lastname: "Smith",
    password: "SecurePass123!",
    bio: "Data scientist exploring the world of ML/AI",
    about: "PhD in Computer Science, specializing in machine learning",
    career_fields: ["Data scientist", "Artificial intelligence and machine learning engineer", "Big Data Developer"]
  },
  {
    email: "carol@example.com",
    username: "carol_ops",
    firstname: "Carol",
    lastname: "Williams",
    password: "SecurePass123!",
    bio: "DevOps engineer automating everything",
    about: "Cloud infrastructure specialist with focus on scalability",
    career_fields: ["DevOps Engineer", "Cloud computing engineer", "Systems analyst"]
  },
  {
    email: "david@example.com",
    username: "david_sec",
    firstname: "David",
    lastname: "Brown",
    password: "SecurePass123!",
    bio: "Security engineer protecting digital assets",
    about: "Cybersecurity expert with 10 years in the field",
    career_fields: ["Security Engineer", "Cybersecurity", "Information security analyst"]
  },
  {
    email: "emma@example.com",
    username: "emma_ui",
    firstname: "Emma",
    lastname: "Davis",
    password: "SecurePass123!",
    bio: "UI/UX designer creating beautiful experiences",
    about: "Design lead with a passion for accessibility",
    career_fields: ["User interface designer", "Front-end web developer", "Product manager"]
  }
]

users_data.each do |user_data|
  career_fields = user_data[:career_fields]

  if career_fields.size > MAX_USER_CAREERS
    raise "#{user_data[:email]} has #{career_fields.size} careers; users can select at most #{MAX_USER_CAREERS}"
  end

  user_attributes = user_data.except(:career_fields)
  careers = Career.where(field: career_fields).to_a
  missing_careers = career_fields - careers.map(&:field)

  if missing_careers.any?
    raise "Missing seeded careers for #{user_data[:email]}: #{missing_careers.join(', ')}"
  end

  user = User.find_or_initialize_by(email: user_attributes[:email])
  attributes_to_assign = user.new_record? ? user_attributes : user_attributes.except(:password)

  User.transaction do
    user.careers = careers if user.persisted?
    user.assign_attributes(attributes_to_assign)
    user.careers = careers if user.new_record?
    user.save!
  end

  puts "  ✓ User: #{user.username} (careers: #{user.careers.pluck(:field).join(', ')})"
end

puts "Total users: #{User.count}"

# ============================================================================
# SEED SAMPLE POSTS
# ============================================================================
puts "\nSeeding sample posts..."

posts_data = [
  {
    title: "Getting Started with Machine Learning",
    content: "Machine learning is transforming the way we build software. From predictive analytics to natural language processing, ML algorithms are becoming essential tools for developers.\n\nIn this post, I explore the fundamentals of ML and how to get started with your first project. We'll cover supervised learning, unsupervised learning, and reinforcement learning with practical examples.",
    career_fields: ['Artificial intelligence and machine learning engineer', 'Computer scientist or computer science researcher', 'Data scientist']
  },
  {
    title: "Best Practices for API Design in 2026",
    content: "RESTful APIs have evolved significantly over the years. In this comprehensive guide, I discuss modern API design patterns including versioning strategies, pagination, filtering, error handling, and documentation best practices that every developer should know.\n\nKey topics include: GraphQL vs REST, API gateway patterns, rate limiting, authentication strategies, and OpenAPI/Swagger documentation.",
    career_fields: ['Software engineer', 'Full-stack web developer', 'Back-end web developer']
  },
  {
    title: "Understanding Database Indexing",
    content: "Database performance is critical for modern applications. Indexing is one of the most effective ways to optimize query performance.\n\nThis post covers B-tree indexes, hash indexes, composite indexes, and when to use each type for maximum performance. Learn how to analyze query execution plans and identify bottlenecks.",
    career_fields: ['Database administrator', 'Software engineer', 'Back-end web developer']
  },
  {
    title: "Introduction to DevOps and CI/CD Pipelines",
    content: "Continuous Integration and Continuous Deployment (CI/CD) are essential practices in modern software development. This guide walks through setting up automated testing, building, and deployment pipelines.\n\nWe'll explore tools like GitHub Actions, GitLab CI, Jenkins, and how to implement infrastructure as code with Terraform and Ansible.",
    career_fields: ['DevOps Engineer', 'Cloud computing engineer', 'Software engineer']
  },
  {
    title: "Cybersecurity Best Practices for Developers",
    content: "Security should be everyone's concern, not just the security team. This post covers essential security practices including input validation, SQL injection prevention, XSS protection, CSRF tokens, and secure authentication.\n\nLearn how to implement security best practices from the ground up and conduct effective security audits.",
    career_fields: ['Information security analyst', 'Security Engineer', 'Cybersecurity']
  },
  {
    title: "Building Responsive UIs with Modern CSS",
    content: "CSS has come a long way from simple styling. With CSS Grid, Flexbox, custom properties, and container queries, we can build incredibly responsive and dynamic user interfaces.\n\nThis tutorial covers modern CSS techniques with practical examples and best practices for creating maintainable, scalable stylesheets.",
    career_fields: ['Front-end web developer', 'User interface designer', 'Full-stack web developer']
  },
  {
    title: "Microservices Architecture: When and Why",
    content: "Microservices can provide scalability and team autonomy, but they also introduce complexity. This post discusses when to use microservices, how to design service boundaries, and common pitfalls to avoid.\n\nReal-world case studies from companies that successfully migrated from monoliths to microservices.",
    career_fields: ['Software engineer', 'Engineering manager', 'Applications architect']
  },
  {
    title: "Mobile App Development: Native vs Cross-Platform",
    content: "Choosing between native and cross-platform mobile development is a critical decision. This comprehensive comparison covers React Native, Flutter, Swift, and Kotlin.\n\nWe analyze performance, development speed, maintainability, and cost factors to help you make the right choice for your project.",
    career_fields: ['Mobile application designer or developer', 'Mobile developer', 'Full-stack web developer']
  },
  {
    title: "Data Engineering Fundamentals",
    content: "Data engineering is the backbone of data-driven organizations. Learn about ETL pipelines, data warehouses, data lakes, and modern data stack tools like Apache Spark, Kafka, and Airflow.\n\nThis guide provides a roadmap for becoming a proficient data engineer.",
    career_fields: ['Big Data Developer', 'Data scientist', 'Database administrator']
  },
  {
    title: "UI/UX Design Principles for Developers",
    content: "Great developers need to understand design principles. This post covers essential UI/UX concepts including user research, wireframing, prototyping, usability testing, and accessibility.\n\nLearn to collaborate effectively with designers and create user-centered applications.",
    career_fields: ['User interface designer', 'Front-end web developer', 'Product manager']
  },
  {
    title: "Cloud Computing: AWS vs Azure vs GCP",
    content: "Choosing the right cloud provider is crucial for your project's success. This detailed comparison covers compute services, storage options, databases, networking, pricing models, and developer experience across AWS, Azure, and Google Cloud Platform.\n\nIncludes decision matrices and real-world recommendations.",
    career_fields: ['Cloud computing engineer', 'Network architect', 'DevOps Engineer']
  },
  {
    title: "Testing Strategies for Modern Applications",
    content: "Comprehensive testing is essential for maintaining code quality. This guide covers unit testing, integration testing, end-to-end testing, and performance testing.\n\nLearn about testing frameworks, mocking strategies, test data management, and how to build a robust testing culture in your team.",
    career_fields: ['Software engineer', 'Software tester', 'Software quality assurance']
  },
  {
    title: "The Rise of Edge Computing",
    content: "Edge computing is bringing computation closer to users, reducing latency and improving performance. This post explores edge architectures, use cases, and how companies are leveraging edge computing for real-time applications.\n\nWe cover edge functions, CDN evolution, and practical implementation strategies.",
    career_fields: ['Cloud computing engineer', 'Network architect', 'Systems analyst']
  },
  {
    title: "Building Accessible Web Applications",
    content: "Accessibility isn't optional—it's a necessity. This comprehensive guide covers WCAG guidelines, ARIA labels, keyboard navigation, screen reader testing, and automated accessibility testing tools.\n\nLearn how to build inclusive applications that work for everyone.",
    career_fields: ['Front-end web developer', 'User interface designer', 'Software quality assurance']
  },
  {
    title: "Blockchain Beyond Cryptocurrency",
    content: "Blockchain technology has applications far beyond Bitcoin and Ethereum. This post explores smart contracts, decentralized applications, supply chain tracking, and digital identity management.\n\nUnderstand the fundamentals of blockchain and its potential to transform industries.",
    career_fields: ['Software engineer', 'Computer scientist or computer science researcher', 'Research and development (R&D) scientist']
  },
  {
    title: "Effective Code Review Practices",
    content: "Code reviews are crucial for maintaining code quality and sharing knowledge across teams. This guide covers best practices for conducting effective code reviews, providing constructive feedback, and building a positive review culture.\n\nIncludes checklists and common pitfalls to avoid.",
    career_fields: ['Software engineer', 'Engineering manager', 'Software business analyst']
  },
  {
    title: "Introduction to Kubernetes",
    content: "Kubernetes has become the de facto standard for container orchestration. This beginner-friendly guide covers pods, services, deployments, and how to deploy your first application on a Kubernetes cluster.\n\nWe'll also explore Helm charts and monitoring strategies.",
    career_fields: ['DevOps Engineer', 'Cloud computing engineer', 'Systems analyst']
  },
  {
    title: "Python for Data Analysis",
    content: "Python is the go-to language for data analysis. This tutorial covers pandas, NumPy, matplotlib, and Jupyter notebooks for exploring and visualizing data.\n\nLearn how to clean, transform, and analyze datasets to extract meaningful insights.",
    career_fields: ['Data scientist', 'Big Data Developer', 'Computer science professor']
  },
  {
    title: "Securing APIs with OAuth 2.0 and OIDC",
    content: "Modern APIs require robust authentication. This deep dive covers OAuth 2.0 flows, OpenID Connect, JWT tokens, scopes, and how to implement secure authentication for your APIs.\n\nIncludes code examples and common security mistakes to avoid.",
    career_fields: ['Information security analyst', 'Back-end web developer', 'Security Engineer']
  },
  {
    title: "The Future of Web Development: What's Next?",
    content: "Web development continues to evolve rapidly. This post explores emerging trends including WebAssembly, server components, AI-assisted development, low-code platforms, and the future of JavaScript frameworks.\n\nWhat should developers focus on learning next?",
    career_fields: ['Full-stack web developer', 'Software engineer', 'Computer science professor']
  }
]

posts_data.each_with_index do |post_data, index|
  # Pick a random user
  user = User.order("RANDOM()").first

  unless user
    puts "  ⚠ No users available, skipping post creation"
    break
  end

  post = Post.new(
    title: post_data[:title],
    content: post_data[:content],
    user: user,
    author: user.username
  )

  if post.save
    # Associate with careers
    career_fields = post_data[:career_fields]
    careers = Career.where(field: career_fields)
    post.careers << careers

    puts "  ✓ Post #{index + 1}/#{posts_data.length}: #{post.title} (by #{user.username})"
  else
    puts "  ✗ Failed: #{post_data[:title]} - #{post.errors.full_messages.join(', ')}"
  end
end

# ============================================================================
# SUMMARY
# ============================================================================
puts "\n" + "="*60
puts "SEEDING COMPLETE! 🌱"
puts "="*60
puts "Careers:  #{Career.count}"
puts "Users:    #{User.count}"
puts "Posts:    #{Post.count}"

# Comments count (table might not exist yet)
if ActiveRecord::Base.connection.table_exists?('comments')
  puts "Comments: #{Comment.count}"
else
  puts "Comments: table not created yet (run migrations)"
end

puts "="*60
