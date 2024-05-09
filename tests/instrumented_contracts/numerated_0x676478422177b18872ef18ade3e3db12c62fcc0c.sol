1 pragma solidity ^0.6.7;
2 
3 interface IERC1155 {
4     function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory);
5     function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external;
6 }
7 
8 contract Claimer {
9 
10     IERC1155 public tokens;
11     address  public deployer;
12     uint256  public end;
13 
14     uint256[] public batches = [1,2,3,4,5];
15 
16     constructor() public {
17         tokens = IERC1155(0xb9341CCa0A5F04b804F7b3a996A74726923359a8);
18         deployer = msg.sender;
19         end = block.timestamp + 2 weeks;
20     }
21 
22     function claim(address payable _user) public {
23         address[] memory user = new address[](5);
24         user[0] = _user;
25         user[1] = _user;
26         user[2] = _user;
27         user[3] = _user;
28         user[4] = _user;
29         uint256[] memory balances = tokens.balanceOfBatch(user, batches);
30         uint256 sum = 0;
31         for (uint i = 0; i < balances.length; i++){
32             sum += balances[i];
33         }
34         tokens.safeBatchTransferFrom(_user, address(this), batches, balances, new bytes(0x0));
35         _user.transfer(sum * 1 ether);
36     }
37 
38     function returnEth(address payable _who) external {
39         require(msg.sender == deployer, "!deployer");
40         require(block.timestamp > end, "not yet");
41         _who.transfer(address(this).balance);
42     }
43     
44     receive() external payable {}
45     
46     function onERC1155BatchReceived(address _operator, address _from, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external pure returns(bytes4) {
47         return bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"));
48     }
49 
50 }