document.getElementById('year')?.appendChild(document.createTextNode(new Date().getFullYear()));
const toggle = document.querySelector('.nav-toggle');
const nav = document.querySelector('.nav');
toggle?.addEventListener('click',()=>{ nav?.classList.toggle('open'); nav.style.display = nav.classList.contains('open') ? 'flex' : 'none'; });