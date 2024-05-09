1 pragma solidity ^0.4.24;
2 
3 contract ERC20Interface {
4     function totalSupply() public view returns (uint);
5     function balanceOf(address tokenOwner) public view returns (uint balance);
6     function transfer(address to, uint tokens) public returns (bool success);
7 
8     
9     //function allowance(address tokenOwner, address spender) public view returns (uint remaining);
10     //function approve(address spender, uint tokens) public returns (bool success);
11     //function transferFrom(address from, address to, uint tokens) public returns (bool success);
12     
13     event Transfer(address indexed from, address indexed to, uint tokens);
14     //event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
15 }
16 
17 contract Ownable {
18   address public owner;
19 
20   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21 
22   constructor() public {
23     owner = msg.sender;
24   }
25 
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   function transferOwnership(address newOwner) public onlyOwner {
32     require(newOwner != address(0));
33     emit OwnershipTransferred(owner, newOwner);
34     owner = newOwner;
35   }
36 
37 }
38 
39 
40 contract medcarednaio is ERC20Interface, Ownable{
41     string public name = "medcaredna.io";
42     string public symbol = "mcd";
43     uint public decimals = 18;
44     
45     uint public supply;
46     address public founder;
47     
48     mapping(address => uint) public balances;
49 
50 
51  event Transfer(address indexed from, address indexed to, uint tokens);
52 
53 
54     constructor() public{
55         supply = 10000000000000000000000000;
56         founder = msg.sender;
57         balances[founder] = supply;
58     }
59     
60     
61     function totalSupply() public view returns (uint){
62         return supply;
63     }
64     
65     function balanceOf(address tokenOwner) public view returns (uint balance){
66          return balances[tokenOwner];
67      }
68      
69      
70     //transfer from the owner balance to another address
71     function transfer(address to, uint tokens) public returns (bool success){
72          require(balances[msg.sender] >= tokens && tokens > 0);
73          
74          balances[to] += tokens;
75          balances[msg.sender] -= tokens;
76          emit Transfer(msg.sender, to, tokens);
77          return true;
78      }
79      
80      
81      function burn(uint256 _value) public returns (bool success) {
82         require(balances[founder] >= _value);   // Check if the sender has enough
83         balances[founder] -= _value;            // Subtract from the sender
84         supply -= _value;                      // Updates totalSupply
85         return true;
86     }
87      
88 }