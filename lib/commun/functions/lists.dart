
findById(List list, String id) {
  try {
    return list.firstWhere((object) => object.id == id);
  } catch (e) {
    if (e is StateError && e.message == 'No element') {
      return null; 
    }
  }
}