1 contract Ownable {
2   address public owner;
3 
4 
5   /**
6    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
7    * account.
8    */
9   function Ownable() {
10     owner = msg.sender;
11   }
12 
13 
14   /**
15    * @dev Throws if called by any account other than the owner.
16    */
17   modifier onlyOwner() {
18     if (msg.sender != owner) {
19       throw;
20     }
21     _;
22   }
23 
24 
25   /**
26    * @dev Allows the current owner to transfer control of the contract to a newOwner.
27    * @param newOwner The address to transfer ownership to.
28    */
29   function transferOwnership(address newOwner) onlyOwner {
30     if (newOwner != address(0)) {
31       owner = newOwner;
32     }
33   }
34 
35 }
36 
37 
38 contract ERC20Basic {
39   uint public totalSupply;
40   function balanceOf(address who) constant returns (uint);
41   function transfer(address to, uint value) returns (bool);
42   event Transfer(address indexed from, address indexed to, uint value);
43 }
44 
45 contract ERC20 is ERC20Basic {
46   function allowance(address owner, address spender) constant returns (uint);
47   function transferFrom(address from, address to, uint value) returns (bool);
48   function approve(address spender, uint value) returns (bool);
49   event Approval(address indexed owner, address indexed spender, uint value);
50 }
51 
52 /*
53 The owner (or anyone) will deposit tokens in here
54 The owner calls the multisend method to send out payments
55 */
56 contract BatchedPayments is Ownable {
57 
58     mapping(bytes32 => bool) successfulPayments;
59 
60 
61     function paymentSuccessful(bytes32 paymentId) public constant returns (bool){
62         return (successfulPayments[paymentId] == true);
63     }
64 
65     //withdraw any eth inside
66     function withdraw() public onlyOwner {
67         msg.sender.transfer(this.balance);
68     }
69 
70     function send(address _tokenAddr, address dest, uint value)
71     public onlyOwner
72     returns (bool)
73     {
74      return ERC20(_tokenAddr).transfer(dest, value);
75     }
76 
77     function multisend(address _tokenAddr, bytes32 paymentId, address[] dests, uint256[] values)
78     public onlyOwner
79     returns (uint256)
80      {
81 
82         require(dests.length > 0);
83         require(values.length >= dests.length);
84         require(successfulPayments[paymentId] != true);
85 
86         uint256 i = 0;
87         while (i < dests.length) {
88            require(ERC20(_tokenAddr).transfer(dests[i], values[i]));
89            i += 1;
90         }
91 
92         successfulPayments[paymentId] = true;
93 
94         return (i);
95 
96     }
97 
98 
99 
100 }