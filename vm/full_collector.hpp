namespace factor {

struct full_policy {
  factor_vm* parent;
  tenured_space* tenured;

  explicit full_policy(factor_vm* parent)
      : parent(parent), tenured(parent->data->tenured) {}

  bool should_copy_p(object* untagged) {
    return !tenured->contains_p(untagged);
  }

  void promoted_object(object* obj) {
    tenured->state.set_marked_p((cell)obj, obj->size());
    parent->mark_stack.push_back((cell)obj);
  }

  void visited_object(object* obj) {
    if (!tenured->state.marked_p((cell)obj))
      promoted_object(obj);
  }
};

}
