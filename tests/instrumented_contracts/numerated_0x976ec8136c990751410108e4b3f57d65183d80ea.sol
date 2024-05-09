1 pragma solidity ^0.4.21;
2 
3 /*
4 *   Bug Bounty One
5 *
6 *   This contract has a bug in it. Find it.  Use it.  Drain it.
7 *   
8 * //*** A Game Developed By:
9 *   _____       _         _         _ ___ _         
10 *  |_   _|__ __| |_  _ _ (_)__ __ _| | _ (_)___ ___ 
11 *    | |/ -_) _| ' \| ' \| / _/ _` | |   / (_-</ -_)
12 *    |_|\___\__|_||_|_||_|_\__\__,_|_|_|_\_/__/\___|
13 *   
14 *   © 2018 TechnicalRise.  Written in March 2018.  
15 *   All rights reserved.  Do not copy, adapt, or otherwise use without permission.
16 *   https://www.reddit.com/user/TechnicalRise/
17 *  
18 */
19 
20 /*
21 *  TocSick won this round on Mar-26-2018 04:11:54 AM +UTC
22 *  You can read the solution source here:
23 *  https://etherscan.io/address/0x7ec3570f627d1b1d1aac3e0c251a27e94e42babb#code
24 *  And learn more about BugBounty at https://discord.gg/nbcdJ2m
25 */
26 
27 contract secretHolder {
28     uint secret;
29     function getSecret() public returns(uint) {
30         return secret++;
31     }
32 }
33 
34 contract BugBountyOne {
35 
36     mapping(address => bool) public authorizedToDrain;
37     mapping(address => bool) public notAllowedToDrain;
38     address public TechnicalRise; // TechnicalRise is not allowed to drain
39     address public CryptoKitties = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
40     uint private secretSeed;
41     secretHolder private s = new secretHolder();
42 
43 	function BugBountyOne() public {
44 	    TechnicalRise = msg.sender;
45 	    notAllowedToDrain[TechnicalRise] = true;
46 	    secretSeed = uint(keccak256(now, block.coinbase));
47 	}
48 	
49 	function drainMe(uint _guess) public payable {
50         if(notAllowedToDrain[msg.sender]) return;
51 
52         if(authorizedToDrain[msg.sender] && msg.value >= 1 finney && _guess == _prand()) {
53             TechnicalRise.transfer(address(this).balance / 20);
54             msg.sender.transfer(address(this).balance);
55             notAllowedToDrain[msg.sender] = true;
56         }
57     }
58     
59     function _prand() private returns (uint) {
60         uint seed1 = s.getSecret();
61         uint seed2 = uint(block.coinbase); // Get Miner's Address
62         uint seed3 = now; // Get the timestamp
63         uint seed4 = CryptoKitties.balance;
64         uint rand = uint(keccak256(seed1, seed2, seed3, seed4));
65         seed1 = secretSeed;
66 	    return rand;
67     }
68     
69     function authorizeAddress(address _addr) public payable {
70         if(msg.value >= 10 finney) {
71             authorizedToDrain[_addr] = true;
72         }
73     }
74     
75     function getSource() public view returns(string) {
76         if(authorizedToDrain[msg.sender]) {
77             return "https://pastebin.com/9X0UreSa";
78         }
79     }
80     
81     function () public payable {
82         if(msg.value >= 10 finney) {
83             authorizedToDrain[msg.sender] = true;
84         }
85     }
86 }