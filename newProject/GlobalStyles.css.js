import styled, { createGlobalStyle } from 'styled-components';
import reset from 'styled-reset';
import Raleway from './fonts/Raleway.ttf';

export const GlobalStyles = createGlobalStyle`
  /* stylelint-disable */
  ${reset}
  /* stylelint-enable */
  
  @font-face {
    font-display: swap;
    font-family: Raleway;
    font-style: normal;
    font-weight: 500;
    src: local('Raleway'), url(${Raleway}) format('truetype');
  }
  
  :root {
    --backgroundColor: whitesmoke;
    --itemBackgroundColor: white;
    --fontColor: black;
    --headerColor: #066FC3;
    --headerFontColor: white;
    --white: white;
    --boxShadow: 0 3px 3px rgba(0, 0, 0, 0.2);
    
    font-size: calc(12px + 0.2vw);
  }
  
  @media (prefers-color-scheme: dark) {
    :root {
      --backgroundColor: #23272A;
      --itemBackgroundColor: #2C2F33;
      --fontColor: white;
      --headerColor: #7289DA;
      --headerFontColor: white;
      --boxShadow: 0 3px 3px rgba(255, 255, 255, 0.2);
    }
  }
  
  html {
    max-width: 1000px;
    margin: auto;
    background-color: var(--backgroundColor);
    color: var(--fontColor);
    font-family: Raleway, sans-serif;
  }
  
  a[href^='/blog/'], 
  a[href^='/portfolio/'],
  a:visited[href^='/blog/'], 
  a:visited[href^='/portfolio/'] {
    color: var(--fontColor);
    text-decoration-style: dotted;
  }
  
  h1 {
    font-size: 3.815rem;
    line-height: 5.7225rem;
  }
  
  h2 {
    font-size: 3.052rem;
    line-height: 4.578rem;
  }
  
  h3 {
    font-size: 2.441rem;
    line-height: 3.6615rem;
  }
  
  h4 {
    font-size: 1.953rem;
    line-height: 2.9295rem;
  }
  
  h5 {
    font-size: 1.563rem;
    line-height: 2.3445rem;
  }
  
  h6 {
    font-size: 1.25rem;
    line-height: 1.875rem;
  }
  
  body {
    margin: 1rem 0;
    font-size: 1rem;
    line-height: 1.5rem;
  }
  
  img {
    max-width: 100%;
  }
  
  blockquote {
    padding: 0.5em 10px;
    margin: 1.5em 10px;
  }
`;

export const TapTarget = styled.a`
  display: inline-block;
  width: 50px;
  height: 50px;
`;

export const ItemContainerStyles = styled.div`
  padding: 1rem;
  margin: 1rem 0;
  background: var(--itemBackgroundColor);
  box-shadow: var(--boxShadow);
`;

export const ContentVisibility = styled.div`
  /* stylelint-disable */
  content-visibility: auto;
  contain-intrinsic-size: 1000px 1000px;
  /* stylelint-enable */
`;
