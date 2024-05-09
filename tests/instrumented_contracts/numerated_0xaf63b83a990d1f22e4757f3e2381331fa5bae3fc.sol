1 pragma solidity ^0.5.3;
2 
3 contract TokenERC20 {
4     mapping (address => uint256) public balanceOf;
5     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
6 }
7 contract multiSend{
8     address public baseAddr = 0x500Df47E1dF0ef06039218dCF0960253D89D6658;
9 	TokenERC20 bcontract = TokenERC20(baseAddr);
10     event cannotAirdrop(address indexed addr, uint balance, uint etherBalance);
11     uint public distributedAmount = 2001200;
12 
13     function() external payable { 
14         revert();
15     }
16     
17     function sendOutToken(address[] memory addrs) public {
18         for(uint i=0;i<addrs.length;i++){
19             if(addrs[i] == address(0)) continue;
20             if(bcontract.balanceOf(addrs[i]) >0 || addrs[i].balance < 1 finney){ 
21                 emit cannotAirdrop(addrs[i],bcontract.balanceOf(addrs[i]),addrs[i].balance);
22             }else{
23                 bcontract.transferFrom(msg.sender,addrs[i], 100 * (10 ** uint256(18)));
24                 distributedAmount += 100;
25             } 
26         }
27     }
28 }