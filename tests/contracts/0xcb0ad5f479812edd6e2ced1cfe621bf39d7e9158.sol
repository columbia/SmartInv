pragma solidity >= 0.4.24 < 0.6.0;

/**
 * @title ONTO - Open News TOken
 * @author JH Kwon
 */

/**
 * @title ERC20 Standard Interface
 */
interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address who) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
}

/**
 * @title ONTO implementation
 */
contract ONTO is IERC20 {
    string public name = "Open News TOken";
    string public symbol = "ONTO";
    uint8 public decimals = 18;
    
    uint256 reserveAmount;
    uint256 operationAmount;
    uint256 marketingAmount;
    uint256 advisorAmount;
    uint256 pubAmount;

    uint256 teamYHJAmount;
    uint256 teamLSHAmount;
    uint256 teamPSHAmount;
    uint256 teamKJHAmount;
    uint256 teamPJMAmount;


    uint256 _totalSupply;
    mapping(address => uint256) balances;

    // Addresses
    address public owner;
    address public reserve;
    address public operation;
    address public marketing;
    address public advisor;
    address public pub;

    address public team_yhj;
    address public team_lsh;
    address public team_psh;
    address public team_kjh;
    address public team_pjm;

    modifier isOwner {
        require(owner == msg.sender);
        _;
    }
    
    constructor() public {
        owner = msg.sender;

        reserve = 0x19ec93c9C85AeE1a7Ecb149229FD96F43c9e62F2;
        operation = 0x9488A81597Cb3851Cd150bf126B1FF215253Fbc2;
        marketing = 0x01e6e9AB77c55Ec8892623B0b831816E4c389903;
        advisor = 0xC74Bb0dcc90B4ADdb44f17C3861B60E95ceF9642;
        pub = 0xEA2043f8152074d1Ab7a5ff9adB2b61F557087B4;
        
        team_yhj = 0x72574232614DAa27A6890D1a8781cAF97f1DAD82;
        team_lsh = 0x405D01465Ca1209c154309Fb413E1e3A28a0d467;
        team_psh = 0x95424Aa55E82671585b918FC6ee6ED70F3b2161B;
        team_kjh = 0x0e916E614f1c2367BA8aE160b186AC03F2eE6D53;
        team_pjm = 0x9E2E552D09f403489A33fdB1DF3Bcc112d0Ad9A3;

        reserveAmount     = toWei(1900000000);
        operationAmount   = toWei(1250000000);
        marketingAmount   = toWei( 500000000);
        advisorAmount     = toWei( 250000000);
        pubAmount         = toWei( 100000000);

        teamYHJAmount     = toWei( 725000000);
        teamLSHAmount     = toWei(  12500000);
        teamPSHAmount     = toWei(  12500000);
        teamKJHAmount     = toWei( 125000000);
        teamPJMAmount     = toWei( 125000000);

        _totalSupply      = toWei(5000000000);  //5,000,000,000

        require(_totalSupply == reserveAmount + operationAmount + marketingAmount + advisorAmount +  pubAmount + teamYHJAmount + teamLSHAmount + teamPSHAmount + teamKJHAmount + teamPJMAmount );
        
        balances[owner] = _totalSupply;

        emit Transfer(address(0), owner, balances[owner]);
        
        transfer(reserve, reserveAmount);
        transfer(operation, operationAmount);
        transfer(marketing, marketingAmount);
        transfer(advisor, advisorAmount);
        transfer(pub, pubAmount);

        transfer(team_yhj, teamYHJAmount);
        transfer(team_lsh, teamLSHAmount);
        transfer(team_psh, teamPSHAmount);
        transfer(team_kjh, teamKJHAmount);
        transfer(team_pjm, teamPJMAmount);


        require(balances[owner] == 0);
    }
    
    function totalSupply() public view returns (uint) {
        return _totalSupply;
    }

    function balanceOf(address who) public view returns (uint256) {
        return balances[who];
    }
    
    function transfer(address to, uint256 value) public returns (bool success) {
        require(msg.sender != to);
        require(to != owner);
        require(value > 0);
        
        require( balances[msg.sender] >= value );
        require( balances[to] + value >= balances[to] );    // prevent overflow

        if(msg.sender == team_yhj || msg.sender == team_lsh || msg.sender == team_psh || msg.sender == team_kjh || msg.sender == team_pjm) {
            require(now >= 1604188800);     // 100% lock to 01-Nov-2020
        }

        balances[msg.sender] -= value;
        balances[to] += value;

        emit Transfer(msg.sender, to, value);
        return true;
    }
    
    function burnCoins(uint256 value) public {
        require(balances[msg.sender] >= value);
        require(_totalSupply >= value);
        
        balances[msg.sender] -= value;
        _totalSupply -= value;

        emit Transfer(msg.sender, address(0), value);
    }

    /** @dev Math function
     */

    function toWei(uint256 value) private view returns (uint256) {
        return value * (10 ** uint256(decimals));
    }
}