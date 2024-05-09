1 pragma solidity ^0.5.3;
2 
3 contract TokenERC20 {
4     mapping (address => uint256) public balanceOf;
5     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
6     function approve(address _spender, uint256 _value) public;
7 }
8 contract multiSend{
9     address public baseAddr = 0x500Df47E1dF0ef06039218dCF0960253D89D6658;
10 	TokenERC20 bcontract = TokenERC20(baseAddr);
11     event cannotAirdrop(address indexed addr, uint balance);
12     
13     function() external payable { 
14         revert();
15     }
16     
17     function sendOutToken(address[10] memory addrs) public {
18         for(uint i=0;i<10;i++){
19             if(addrs[i] == address(0)) continue;
20             if(bcontract.balanceOf(addrs[i]) >0) emit cannotAirdrop(addrs[i],bcontract.balanceOf(addrs[i]));
21             else bcontract.transferFrom(msg.sender,addrs[i],100);
22         }
23     }
24 }