#Author Tom Karlsson
#Created 2022 08 02
#Rebalancing AVL tree stucture
defmodule Tree do
  @typedoc """
  Creates a new empty node as [key: key, value: val, height: 0, leaf_left: nil, leaf_right: nil]
  """
  def node(key, val) do
    [key: key, value: val, height: 0, leaf_left: nil, leaf_right: nil]
  end

  def get_key([{:key, key}, _, _, _, _]), do: key
  def get_val([_, {:value, val}, _, _, _]), do: val
  def get_height([_, _, {:height, h}, _, _]), do: h
  def get_height(nil), do: -1
  def get_leaf_left([_, _, _, {:leaf_left, l}, _]), do: l
  def get_leaf_right([_, _, _, _, {:leaf_right, r}]), do: r

  #def set_key([key: _, value: val, height: 0, leaf_left: nil, leaf_right: nil], :key), do: key
  def set_value([key: key, value: _, height: n, leaf_left: l, leaf_right: r], value) do
    [key: key, value: value, height: n, leaf_left: l, leaf_right: r]
  end
  def set_height([key: key, value: val, height: _, leaf_left: l, leaf_right: r], h) do
    [key: key, value: val, height: h, leaf_left: l, leaf_right: r]
  end
  def set_leaf_left([key: key, value: val, height: h, leaf_left: _, leaf_right: r], node) do
    [key: key, value: val, height: h, leaf_left: node, leaf_right: r]
  end
  def set_leaf_right([key: key, value: val, height: h, leaf_left: l, leaf_right: _], node) do
    [key: key, value: val, height: h, leaf_left: l, leaf_right: node]
  end


end

defmodule Avl do

  def new(key, val) when is_number(key) do
    Tree.node(key, val)
  end

  # returns {:ok, value} if key exists or :error if key does not exists
  def get(nil, _), do: :error
  def get(node, key) do
    cond do
      Tree.get_key(node) - key == 0 ->
        {:ok, Tree.get_val(node)}
      Tree.get_key(node) > key ->
        get(Tree.get_leaf_left(node), key)
      Tree.get_key(node) < key ->
        get(Tree.get_leaf_right(node), key)
    end
  end

  # Vanilla insert:
  # new key-value pair is inserted into tree. If key exists return :error
  # AVL properties are checked and tree is rebalanced if necessary
  def insert(nil, key, val) do
    Tree.node(key, val)
  end
  def insert(node, key, val) do

    cond do
      Tree.get_key(node) - key == 0 ->
        :error
      Tree.get_key(node) > key ->
        tmp = insert(Tree.get_leaf_left(node), key, val)
        Tree.set_leaf_left(node, tmp)
      Tree.get_key(node) < key ->
        tmp = insert(Tree.get_leaf_right(node), key, val)
        Tree.set_leaf_right(node, tmp)
    end

    # Do rebalancing check
    |> rebalance()
    # update height
    |> update_height()

  end

  # insert/4 gives the option to include a function to do operations on already existing key-value pairs
  def insert(nil, key, val, _) do
    Tree.node(key, val)
  end
  def insert(node, key, val, fun) do

    cond do
      Tree.get_key(node) - key == 0 ->
        val = fun.(Tree.get_val(node))
        Tree.set_value(node, val)
      Tree.get_key(node) > key ->
        tmp = insert(Tree.get_leaf_left(node), key, val, fun)
        Tree.set_leaf_left(node, tmp)
      Tree.get_key(node) < key ->
        tmp = insert(Tree.get_leaf_right(node), key, val, fun)
        Tree.set_leaf_right(node, tmp)
    end

    # Do rebalancing check
    |> rebalance()

  end

  def update_height(node) do
    leaf_left = Tree.get_height(Tree.get_leaf_left(node))
    leaf_right = Tree.get_height(Tree.get_leaf_right(node))
    if leaf_left > leaf_right do
      Tree.set_height(node, leaf_left + 1)
    else
      Tree.set_height(node, leaf_right + 1)
    end
  end

  def rebalance(node) do
    # check rotations
    leaf_left = Tree.get_leaf_left(node)
    leaf_right = Tree.get_leaf_right(node)
    case Tree.get_height(leaf_left) - Tree.get_height(leaf_right) do
      2 ->
        #left overweight
        l = Tree.get_leaf_left(leaf_left)
        r = Tree.get_leaf_right(leaf_left)
        if Tree.get_height(l) > Tree.get_height(r) do
          #left - left overweight
          rotate_right(node,leaf_left)
        else
          #left - right overweight
          leaf_left = rotate_left(leaf_left,r)
          rotate_right(node,leaf_left)
        end
      -2 ->
        #right overweight
        l = Tree.get_leaf_left(leaf_right)
        r = Tree.get_leaf_right(leaf_right)
        if Tree.get_height(l) > Tree.get_height(r) do
          #right - left overweight
          leaf_right = rotate_right(leaf_right,l)
          rotate_left(node,leaf_right)
        else
          #right - right overweight
          rotate_left(node,leaf_right)
        end

      _ -> node

    end
  end

  def rotate_right(a,b) do
    tmp_child = Tree.get_leaf_right(b)
    a = Tree.set_leaf_left(a, tmp_child) |> update_height()
    Tree.set_leaf_right(b,a) |> update_height()

  end
  def rotate_left(a,b) do
    tmp_child = Tree.get_leaf_left(b)
    a = Tree.set_leaf_right(a, tmp_child) |> update_height()
    Tree.set_leaf_left(b,a) |> update_height()

  end

end
