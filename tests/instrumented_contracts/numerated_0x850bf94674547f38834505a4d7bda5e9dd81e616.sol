1 pragma solidity ^0.4.8;
2 
3 
4 /*
5  * ERC20Basic
6  * Simpler version of ERC20 interface
7  * see https://github.com/ethereum/EIPs/issues/20
8  */
9 contract ERC20Basic {
10   uint public totalSupply;
11   function balanceOf(address who) constant returns (uint);
12   function transfer(address to, uint value);
13   event Transfer(address indexed from, address indexed to, uint value);
14   function transferFrom(address from, address to, uint value);
15   function allowance(address owner, address spender) constant returns (uint);  
16 }
17 
18 
19 
20 contract DistributeTokens {
21     ERC20Basic public token;
22     address owner;
23     function DistributeTokens( ERC20Basic _token ) {
24         owner = msg.sender;
25         token = _token;
26     }
27     
28     function checkExpectedTokens( address[] holdersList, uint[] expectedBalance, uint expectedTotalSupply ) constant returns(uint) {
29         uint totalHoldersTokens = 0;
30         uint i;
31         
32         if( token.totalSupply() != expectedTotalSupply ) return 0;
33      
34         for( i = 0 ; i < holdersList.length ; i++ ) {
35             uint holderBalance = token.balanceOf(holdersList[i]);
36             if( holderBalance != expectedBalance[i] ) return 0;
37             
38             totalHoldersTokens += holderBalance;
39         }
40         
41         return totalHoldersTokens;
42     }
43     
44     function distribute( address mainHolder, uint amountToDistribute, address[] holdersList, uint[] expectedBalance, uint expectedTotalSupply ) {
45         if( msg.sender != owner ) throw;
46         if( token.allowance(mainHolder,this) < amountToDistribute ) throw;
47         
48      
49         uint totalHoldersTokens = checkExpectedTokens(holdersList, expectedBalance, expectedTotalSupply);
50         if( totalHoldersTokens == 0 ) throw;
51      
52 
53         for( uint i = 0 ; i < holdersList.length ; i++ ) {
54             uint extraTokens = (amountToDistribute * expectedBalance[i]) / totalHoldersTokens;
55             token.transferFrom(mainHolder, holdersList[i], extraTokens);
56         }
57     }
58 }