1 pragma solidity ^0.4.19;
2 
3 contract EthermiumAffiliates {
4 	mapping(address => address[]) public referrals; // mapping of affiliate address to referral addresses
5 	mapping(address => address) public affiliates; // mapping of referrals addresses to affiliate addresses
6 	mapping(address => bool) public admins; // mapping of admin accounts
7 	string[] public affiliateList;
8 	address public owner;
9 
10 	event New(address affiliate, address referral);
11 
12 	modifier onlyOwner {
13 		assert(msg.sender == owner);
14 		_;
15 	}
16 
17 	modifier onlyAdmin {
18 	    assert(msg.sender == owner || admins[msg.sender]);
19 	    _;
20 	}
21 
22   	function setOwner(address newOwner) onlyOwner {
23 	    owner = newOwner;
24 	}
25 
26 	function setAdmin(address admin, bool isAdmin) public onlyOwner {
27     	admins[admin] = isAdmin;
28   	}
29 
30 	function EthermiumAffiliates (address owner_)
31 	{
32 		owner = owner_;
33 	}
34 
35 	function assignReferral (address affiliate, address referral) public onlyAdmin returns (bool)
36 	{
37 		if (affiliates[referral] != address(0)) return false;
38 		referrals[affiliate].push(referral);
39 		affiliates[referral] = affiliate;
40 		New(affiliate, referral);
41 		return true;
42 	}
43 	
44 
45 	function getAffiliateCount() returns (uint)
46 	{
47 		return affiliateList.length;
48 	}
49 
50 	function getAffiliate(address refferal) public returns (address)
51 	{
52 		return affiliates[refferal];
53 	}
54 
55 	function getReferrals(address affiliate) public returns (address[])
56 	{
57 		return referrals[affiliate];
58 	}
59 }