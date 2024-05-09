1 pragma solidity ^0.4.18;
2 
3 /// @title Ownable contract
4 contract Ownable {
5 
6   address public owner;
7 
8   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
9   
10   function Ownable() public {
11     owner = msg.sender;
12   }
13 
14   modifier onlyOwner() {
15     require(msg.sender == owner);
16     _;
17   }
18 
19   function transferOwnership(address newOwner) onlyOwner public {
20     require(newOwner != address(0));
21     OwnershipTransferred(owner, newOwner);
22     owner = newOwner;
23     }
24 }
25 /// @title Mortal contract - used to selfdestruct once we have no use of this contract
26 contract Mortal is Ownable {
27     function executeSelfdestruct() onlyOwner {
28         selfdestruct(owner);
29     }
30 }
31 
32 /// @title ERC20 contract
33 /// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
34 contract ERC20 {
35   uint public totalSupply;
36   function balanceOf(address who) public constant returns (uint);
37   function transfer(address to, uint value) public returns (bool);
38   event Transfer(address indexed from, address indexed to, uint value);
39   
40   function allowance(address owner, address spender) public constant returns (uint);
41   function transferFrom(address from, address to, uint value) public returns (bool);
42   function approve(address spender, uint value) public returns (bool);
43   event Approval(address indexed owner, address indexed spender, uint value);
44 }
45 
46 /// @title WizzleInfinityHelper contract
47 contract WizzleInfinityHelper is Mortal {
48     
49     mapping (address => bool) public whitelisted;
50     ERC20 public token;
51 
52     function WizzleInfinityHelper(address _token) public {
53         token = ERC20(_token);
54     }
55 
56     /// @dev Whitelist a single address
57     /// @param addr Address to be whitelisted
58     function whitelist(address addr) public onlyOwner {
59         require(!whitelisted[addr]);
60         whitelisted[addr] = true;
61     }
62 
63     /// @dev Remove an address from whitelist
64     /// @param addr Address to be removed from whitelist
65     function unwhitelist(address addr) public onlyOwner {
66         require(whitelisted[addr]);
67         whitelisted[addr] = false;
68     }
69 
70     /// @dev Whitelist array of addresses
71     /// @param arr Array of addresses to be whitelisted
72     function bulkWhitelist(address[] arr) public onlyOwner {
73         for (uint i = 0; i < arr.length; i++) {
74             whitelisted[arr[i]] = true;
75         }
76     }
77 
78     /// @dev Check if address is whitelisted
79     /// @param addr Address to be checked if it is whitelisted
80     /// @return Is address whitelisted?
81     function isWhitelisted(address addr) public constant returns (bool) {
82         return whitelisted[addr];
83     }   
84 
85     /// @dev Transfer tokens to addresses registered for airdrop
86     /// @param dests Array of addresses that have registered for airdrop
87     /// @param values Array of token amount for each address that have registered for airdrop
88     /// @return Number of transfers
89     function airdrop(address[] dests, uint256[] values) public onlyOwner returns (uint256) {
90         uint256 i = 0;
91         while (i < dests.length) {
92            token.transfer(dests[i], values[i]);
93            whitelisted[dests[i]] = true;
94            i += 1;
95         }
96         return (i); 
97     }
98 
99 }