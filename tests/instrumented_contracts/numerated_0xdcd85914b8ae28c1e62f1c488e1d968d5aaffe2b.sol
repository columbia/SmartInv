1 pragma solidity ^0.5.6;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply = 2e28;
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 contract TOPToken is ERC20Basic {
16   bytes32 public name = "TOP Network";
17   bytes32 public symbol = "TOP";
18   uint256 public decimals = 18;
19   address private owner = address(0);
20   bool private active = false;
21 
22   mapping(address => uint256) private balances;
23 
24   event OwnershipTransferred(address indexed orgOwner, address indexed newOwner);
25 
26   constructor() public {
27     owner = msg.sender;
28     balances[owner] = totalSupply;
29     active = true;
30   }
31 
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38   * @dev transfer token for a specified address
39   * @param _to The address to transfer to.
40   * @param _value The amount to be transferred.
41   */
42   function transfer(address _to, uint256 _value) public returns (bool) {
43     require(active);
44     require(_to != address(0));
45     require(_to != msg.sender);
46     require(_value <= balances[msg.sender]);
47 
48     uint256 bal = balances[_to] + _value;
49     require(bal >= balances[_to]);
50 
51     balances[msg.sender] = balances[msg.sender] - _value;
52     balances[_to] = bal;
53 
54     emit Transfer(msg.sender, _to, _value);
55     return true;
56   }
57 
58   /**
59   * @dev Gets the balance of the specified address.
60   * @param _owner The address to query the the balance of.
61   * @return An uint256 representing the amount owned by the passed address.
62   */
63   function balanceOf(address _owner) public view returns (uint256 bal) {
64     require(active);
65     return balances[_owner];
66   }
67 
68   // Only owner can deactivate
69   function deactivate() public onlyOwner {
70     active = false;
71   }
72 
73   // Only owner can activate
74   function activate() public onlyOwner {
75     active = true;
76   }
77 
78   function transferOwnership(address newOwner) public onlyOwner {
79     require(newOwner != address(0));
80     emit OwnershipTransferred(owner, newOwner);
81     owner = newOwner;
82   }
83 
84   // Only owner can kill
85   function kill() public onlyOwner {
86     require(!active);
87     selfdestruct(msg.sender);
88   }
89 }