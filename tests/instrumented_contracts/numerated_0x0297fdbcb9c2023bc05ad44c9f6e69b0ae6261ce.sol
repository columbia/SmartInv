1 pragma solidity ^0.4.21;
2 
3 contract Convert {
4     
5     address owner;
6     address public fromContractAddr;
7     address public toContractAddr;
8     
9     mapping (uint => bool) public isConvert;
10     
11     modifier onlyOwner {
12         require(msg.sender == owner);
13         _;
14     }
15     
16     function Convert() public {
17         owner = msg.sender;
18     }
19     
20     function setFromContractAddr(address _addr) public onlyOwner {
21         fromContractAddr = _addr;
22     }
23     
24     function setToContractAddr(address _addr) public onlyOwner {
25         toContractAddr = _addr;
26     }
27     
28     function getNewToken(uint _tokenId) public {
29         IFrom ifrom = IFrom(fromContractAddr);
30         require(ifrom.ownerOf(_tokenId) == msg.sender);
31         require(isConvert[_tokenId] == false);
32         
33         isConvert[_tokenId] = true;
34         
35         ITo ito = ITo(toContractAddr);
36         ito.issueTokenAndTransfer(1, msg.sender);
37     }
38     
39     /* only read */
40     
41 }
42 
43 interface IFrom {
44     function ownerOf (uint256 _itemId) public view returns (address _owner);
45 }
46 
47 interface ITo {
48     function issueTokenAndTransfer(uint256 _count, address to) public;
49 }