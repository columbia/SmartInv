1 pragma solidity ^ 0.4.16;
2 
3 contract owned {
4     address public owner;
5     
6     function owned() payable {
7         owner = msg.sender;
8     }
9     modifier onlyOwner {
10         require(owner == msg.sender);
11         _;
12     }
13     
14     function changeOwner(address _owner) onlyOwner public {
15         owner = _owner;
16     }
17 }
18 contract Crowdsale is owned {
19     
20     uint256 public totalSupply;
21     mapping (address => uint256) public balanceOf;
22     
23     event Transfer(address indexed from, address indexed to, uint256 value);
24     
25     function Crowdsale() payable owned() {
26         totalSupply = 900000000000000000000000000000;
27         balanceOf[this] = 1000000000000000000000000;
28         balanceOf[owner] = totalSupply - balanceOf[this];
29         Transfer(this, owner, balanceOf[owner]);
30     }
31     
32     function () payable {
33         require(balanceOf[this] > 0);
34         uint256 tokens = 5000000000000000000000 * msg.value / 1000000000000000000;
35         if (tokens > balanceOf[this]) {
36             tokens = balanceOf[this];
37             uint valueWei = tokens * 1000000000000000000 / 5000000000000000000000;
38             msg.sender.transfer(msg.value - valueWei);
39         }
40         require(tokens > 0);
41         balanceOf[msg.sender] += tokens;
42         balanceOf[this] -= tokens;
43         Transfer(this, msg.sender, tokens);
44     }
45 }
46 contract Token is Crowdsale {
47     
48     string  public standard    = 'Token 0.1';
49     string  public name        = 'SocCoin';
50     string  public symbol      = 'SCN';
51     uint8   public decimals    = 18;
52     
53     function Token() payable Crowdsale() {}
54     
55     function transfer(address _to, uint256 _value) public {
56         require(balanceOf[msg.sender] >= _value);
57         balanceOf[msg.sender] -= _value;
58         balanceOf[_to] += _value;
59         Transfer(msg.sender, _to, _value);
60     }
61 }
62 
63 contract SimpleContract is Token {
64     
65     function SimpleContract() payable Token() {}
66     
67     function withdraw() public onlyOwner {
68         owner.transfer(this.balance);
69     }
70     function killme() public onlyOwner {
71         selfdestruct(owner);
72     }
73 }