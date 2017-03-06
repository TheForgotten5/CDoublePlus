import java.util.*;

public class BST
{
  Node root;
  public static int num;

  public static void setNumber(int a)
  {
    num = a;
  }

  public static int getNumber()
  {
    return num;
  }

  public void insert(int key)
  {
    Node newNode = new Node(key);
    if (root == null) {
      root = newNode;
      return;
    } else {
      Node focusNode = root;
      Node parent;

      while (true) {
        parent = focusNode;

        if (key < focusNode.key) {
          focusNode = focusNode.left;
          if (focusNode == null) {
            parent.left = newNode;
            return;
          }
        } else {
          focusNode = focusNode.right;
          if (focusNode == null) {
            parent.right = newNode;
            return;
          }
        }
      }
    }
  }

  public Node search(int key) {
    Node focusNode = root;

    while (focusNode.key != key) {
      if (key < focusNode.key) {
        focusNode = focusNode.left;
      } else {
        focusNode = focusNode.right;
      }

      if (focusNode == null) {
        return null;
      }
    }
    return focusNode;
  }

  public void inOrder(Node current) {
    if (current != null) {
      inOrder(current.left);
      System.out.println(current.key);
      inOrder(current.right);
    }
  }

  public void preOrder(Node current) {
    if (current != null) {
      System.out.println(current.key);
      inOrder(current.left);
      inOrder(current.right);
    }
  }

  public void postOrder(Node current) {
    if (current != null) {
      inOrder(current.left);
      inOrder(current.right);
      System.out.println(current.key);
    }
  }

  // Main
  public static void main(String[] args)
  {
    BST tree = new BST();
    tree.insert(40);
    tree.insert(20);
    tree.insert(10);
    tree.insert(80);
    tree.insert(75);
    tree.insert(15);
    tree.insert(55);
    tree.insert(65);
    tree.insert(90);
    tree.insert(5);

    tree.inOrder(tree.root);
    // tree.preOrder(tree.root);
    // tree.postOrder(tree.root);

    // Search nodes via user input
    System.out.println("Enter a number to search: \n");
    Scanner userInput = new Scanner(System.in);

    if (userInput.hasNextInt()) {
      setNumber(userInput.nextInt());
      System.out.println("Searching for " + getNumber() + "...");
      Node target = tree.search(getNumber());
      if (target != null) {
        System.out.println("Target " + target.key + " has been found!");
      } else {
        System.out.println("Target not found.");
      }
    }

  }
}

class Node
{
  int key;

  Node left;
  Node right;

  //Constructor
  Node(int key)
  {
    this.key = key;
  }
}
