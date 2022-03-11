class Role {
  Role({required this.role_id, required this.role_name});

  String role_id;
  String role_name;

  static Map<String, dynamic> rolesMap= {
    'A': Role(role_id: 'A', role_name: 'Admin'),
    'E': Role(role_id: 'E', role_name: 'Etablissement'),
    'P': Role(role_id: 'P', role_name: 'Mr. President'),
    'S': Role(role_id: 'S', role_name: 'Service de diplome presidence')
  };

  static List<Role> rolesList = [
    Role(role_id: 'A', role_name: 'Admin'),
    Role(role_id: 'E', role_name: 'Etablissement'),
    Role(role_id: 'P', role_name: 'Mr. President'),
    Role(role_id: 'S', role_name: 'Service de diplome presidence')
  ];
}
