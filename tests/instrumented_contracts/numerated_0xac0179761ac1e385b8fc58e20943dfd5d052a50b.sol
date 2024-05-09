1 pragma solidity ^0.4.8;
2 
3 
4 
5 /*
6  * ERC20 interface
7  * see https://github.com/ethereum/EIPs/issues/20
8  */
9 contract ERC20 {
10   uint public totalSupply;
11   function balanceOf(address who) constant returns (uint);
12   function allowance(address owner, address spender) constant returns (uint);
13 
14   function transfer(address to, uint value) returns (bool ok);
15   function transferFrom(address from, address to, uint value) returns (bool ok);
16   function approve(address spender, uint value) returns (bool ok);
17   event Transfer(address indexed from, address indexed to, uint value);
18   event Approval(address indexed owner, address indexed spender, uint value);
19 }
20 
21 
22 
23 /*
24  * Ownable
25  *
26  * Base contract with an owner.
27  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
28  */
29 contract Ownable {
30   address public owner;
31 
32   function Ownable() {
33     owner = msg.sender;
34   }
35 
36   modifier onlyOwner() {
37     if (msg.sender != owner) {
38       throw;
39     }
40     _;
41   }
42 
43   function transferOwnership(address newOwner) onlyOwner {
44     if (newOwner != address(0)) {
45       owner = newOwner;
46     }
47   }
48 
49 }
50 
51 
52 /**
53  * Issuer manages token distribution after the crowdsale.
54  *
55  * This contract is fed a CSV file with Ethereum addresses and their
56  * issued token balances.
57  *
58  * Issuer act as a gate keeper to ensure there is no double issuance
59  * per address, in the case we need to do several issuance batches,
60  * there is a race condition or there is a fat finger error.
61  *
62  * Issuer contract gets allowance from the team multisig to distribute tokens.
63  *
64  */
65 contract Issuer is Ownable {
66 
67   /** Map addresses whose tokens we have already issued. */
68   mapping(address => bool) public issued;
69 
70   /** Centrally issued token we are distributing to our contributors */
71   ERC20 public token;
72 
73   /** Party (team multisig) who is in the control of the token pool. Note that this will be different from the owner address (scripted) that calls this contract. */
74   address public allower;
75 
76   /** How many addresses have received their tokens. */
77   uint public issuedCount;
78 
79   function Issuer(address _owner, address _allower, ERC20 _token) {
80     owner = _owner;
81     allower = _allower;
82     token = _token;
83   }
84 
85   function issue(address benefactor, uint amount) onlyOwner {
86     if(issued[benefactor]) throw;
87     token.transferFrom(allower, benefactor, amount);
88     issued[benefactor] = true;
89     issuedCount += amount;
90   }
91 
92 }