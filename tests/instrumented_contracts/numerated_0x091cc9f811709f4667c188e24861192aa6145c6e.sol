1 pragma solidity ^0.4.0;
2 
3 contract ERC20 {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8   
9   function allowance(address owner, address spender)
10     public view returns (uint256);
11 
12   function transferFrom(address from, address to, uint256 value)
13     public returns (bool);
14 
15   function approve(address spender, uint256 value) public returns (bool);
16   event Approval(
17     address indexed owner,
18     address indexed spender,
19     uint256 value
20   );
21 }
22 
23 
24 contract MNY {
25     function mine(address token, uint amount) public;
26 }
27 
28 contract mnyminer {
29     
30     address mny = 0xD2354AcF1a2f06D69D8BC2e2048AaBD404445DF6;
31     address futx = 0x8b7d07b6ffB9364e97B89cEA8b84F94249bE459F;
32     address futr = 0xc83355eF25A104938275B46cffD94bF9917D0691;
33 
34     function futrMiner() public payable {
35         require(futr.call.value(msg.value)());
36         uint256 mined = ERC20(futr).balanceOf(address(this));
37         ERC20(futr).approve(mny, mined);
38         MNY(mny).mine(futr, mined);
39         uint256 amount = ERC20(mny).balanceOf(address(this));
40         ERC20(mny).transfer(msg.sender, amount);
41     }
42     
43     
44     function futxMiner() public payable {
45         require(futx.call.value(msg.value)());
46         uint256 mined = ERC20(futx).balanceOf(address(this));
47         ERC20(futx).approve(mny, mined);
48         MNY(mny).mine(futx, mined);
49         uint256 amount = ERC20(mny).balanceOf(address(this));
50         ERC20(mny).transfer(msg.sender, amount);
51     }
52 }