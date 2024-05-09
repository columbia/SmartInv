1 pragma solidity ^0.4.2;
2 
3 contract Owner {
4     //For storing the owner address
5     address public owner;
6     //Constructor for assign a address for owner property(It will be address who deploy the contract) 
7     function Owner() {
8         owner = msg.sender;
9     }
10     //This is modifier (a special function) which will execute before the function execution on which it applied 
11     modifier onlyOwner() {
12         if(msg.sender != owner) throw;
13         //This statement replace with the code of fucntion on which modifier is applied
14         _;
15     }
16     //Here is the example of modifier this function code replace _; statement of modifier 
17     function transferOwnership(address new_owner) onlyOwner {
18         owner = new_owner;
19     }
20 }
21 
22 contract MyToken is Owner {
23     //Common information about coin
24     string public name;
25     string public symbol;
26     uint8  public decimal;
27     uint256 public totalSupply;
28     
29     //Balance property which should be always associate with an address
30     mapping (address => uint256) public balanceOf;
31     //frozenAccount property which should be associate with an address
32     mapping (address => bool) public frozenAccount;
33     
34     //These generates a public event on the blockchain that will notify clients
35     event Transfer(address indexed from, address indexed to, uint256 value);
36     event FrozenFunds(address target, bool frozen);
37     
38     //Construtor for initial supply (The address who deployed the contract will get it) and important information
39     function MyToken(uint256 initial_supply, string _name, string _symbol, uint8 _decimal) {
40         balanceOf[msg.sender] = initial_supply;
41         name = _name;
42         symbol = _symbol;
43         decimal = _decimal;
44         totalSupply = initial_supply;
45     }
46     
47     //Function for transer the coin from one address to another
48     function transfer(address to, uint value) {
49         //checking account is freeze or not
50         if (frozenAccount[msg.sender]) throw;
51         //checking the sender should have enough coins
52         if(balanceOf[msg.sender] < value) throw;
53         //checking for overflows
54         if(balanceOf[to] + value < balanceOf[to]) throw;
55         
56         //substracting the sender balance
57         balanceOf[msg.sender] -= value;
58         //adding the reciever balance
59         balanceOf[to] += value;
60         
61         // Notify anyone listening that this transfer took place
62         Transfer(msg.sender, to, value);
63     }
64     
65     function mintToken(address target, uint256 mintedAmount) onlyOwner{
66         balanceOf[target] += mintedAmount;
67         totalSupply += mintedAmount;
68         
69         Transfer(0,owner,mintedAmount);
70         Transfer(owner,target,mintedAmount);
71     }
72 
73     function freezeAccount(address target, bool freeze) onlyOwner {
74         frozenAccount[target] = freeze;
75         FrozenFunds(target, freeze);
76     }
77     
78 }