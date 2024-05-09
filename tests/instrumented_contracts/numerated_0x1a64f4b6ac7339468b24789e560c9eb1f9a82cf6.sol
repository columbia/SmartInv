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
41   function transfer(address to, uint value);
42   event Transfer(address indexed from, address indexed to, uint value);
43 }
44 
45 contract ERC20 is ERC20Basic {
46   function allowance(address owner, address spender) constant returns (uint);
47   function transferFrom(address from, address to, uint value);
48   function approve(address spender, uint value);
49   event Approval(address indexed owner, address indexed spender, uint value);
50 }
51 
52 
53 contract Multisend is Ownable {
54     
55     function withdraw() onlyOwner {
56         msg.sender.transfer(this.balance);
57     }
58     
59     function send(address _tokenAddr, address dest, uint value)
60     onlyOwner
61     {
62       ERC20(_tokenAddr).transfer(dest, value);
63     }
64     
65     function multisend(address _tokenAddr, address[] dests, uint256[] values)
66     onlyOwner
67       returns (uint256) {
68         uint256 i = 0;
69         while (i < dests.length) {
70            ERC20(_tokenAddr).transfer(dests[i], values[i]);
71            i += 1;
72         }
73         return (i);
74     }
75 }