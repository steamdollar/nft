// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

interface IERC721 {

    // 이벤트
    event Transfer(address indexed _from, address indexed _to, uint indexed _tokenId);
    event Approval(address indexed _from, address indexed _approved, uint indexed _tokenId);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    // _owner가 가진 nft의 총 갯수를 보여주는 함수
    function balanceOf(address _owner) external view returns(uint);
    
    // _tokenId로 그 토큰을 소유한 address를 보여주는 함수
    function ownerOf(uint _tokenId) external view returns(address);

    // token의 소유권 이전에 관련된 함수, _from에서 _to로 _tokenId값을 가진 토큰을 준다
    function transferFrom (address _from, address _to, uint _tokenId) external;

    // 특정 토큰에 대한 위임 관련 함수 (_to 에게 _tokenId)를 위임
    function approve(address _to, uint _tokenId) external;

    // _tokenId를 위임받은 address를 알려주는 함수
    function getApproved(uint _tokenId) external view returns(address);

    // 모든 토큰을 operator에게 위임
    function setApprovalForAll (address _operator, bool _approved) external;

    // 현재 (모든) 토큰들이 _owner에게서 _operator로 위임받은 상태인지를 참/거짓 값을 리턴해 알려주는 함수
    function isApprovedForAll(address _owner, address _operator) external view returns(bool);
}