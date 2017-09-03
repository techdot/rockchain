pragma solidity ^0.4.11;


import './SafeMath.sol';
import './ERC20.sol';
import './ReceivingContract.sol';

contract ROKToken is ERC20 {
  using SafeMath for uint256;
    /* Public variables of the token */
  string public constant name = 'ROK Token';
  string public constant symbol = 'ROK';
  uint public constant decimals = 18;
  uint public totalSupply;
  uint public initialSupply;

  mapping(address => uint) balances;
  mapping (address => mapping (address => uint)) allowed;


  /*event Burn(address indexed burner, uint indexed value);*/
  event Transfer(address indexed from, address indexed to, uint value);
  event Approval(address indexed owner, address indexed spender, uint value);
  event Burn(address indexedburner, uint value);

  
  function ROKToken() {
    initialSupply = 100000000; //100,000,000 ROK tokens
    totalSupply = initialSupply;
    balances[msg.sender] = initialSupply;// Give the creator all initial tokens
  }

  function burn(uint256 _value) returns (bool){
    require(_value > 0);

    address burner = msg.sender;
    balances[burner] = balances[burner].sub(_value);
    totalSupply = totalSupply.sub(_value);
    Burn(burner, _value);
  }

  function transfer(address _to, uint _value) returns (bool) {
    require(_to != address(0));

    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    Transfer(msg.sender, _to, _value);
    return true;
  }

  function transferFrom(address _from, address _to, uint _value) returns (bool) {
    require(_to != address(0));
    var _allowance = allowed[_from][msg.sender];

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    allowed[_from][msg.sender] = _allowance.sub(_value);
    Transfer(_from, _to, _value);
    return true;
  }

  function balanceOf(address _owner) constant returns (uint balance) {
    return balances[_owner];
  }

  function approve(address _spender, uint _value) returns (bool) {
    require((_value == 0) || (allowed[msg.sender][_spender] == 0));

    allowed[msg.sender][_spender] = _value;
    Approval(msg.sender, _spender, _value);
    return true;
  }

    /* Approve and then comunicate the approved contract in a single tx */
  function approveRefund (address _spender, bytes _extraData){
      ReceivingContract spender = ReceivingContract(_spender);
      spender.refund(msg.sender, this, _extraData);
  }

  function allowance(address _owner, address _spender) constant returns (uint remaining) {
    return allowed[_owner][_spender];
  }
}