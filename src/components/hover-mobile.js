// Create the dialog element and append it directly to the body once
const dialog = document.createElement('div');
dialog.id = 'dialog';
document.body.appendChild(dialog);

const circles = document.querySelectorAll('.tooltip_circle');

circles.forEach(circle => {

  // ✅ ADDED: Extracted shared tooltip logic into a reusable function
  const showTooltip = (event) => {

    if (event.cancelable) {
    event.preventDefault();
    }

    // ✅ ADDED: Prevent default behavior on mobile to avoid touch scrolling
    if (event.type === 'touchstart') {
      event.preventDefault();
    }

    const svg = circle.ownerSVGElement;
    const point = svg.createSVGPoint();

    point.x = +circle.getAttribute('cx');
    point.y = +circle.getAttribute('cy');

    // Convert to screen coordinates
    const screenPoint = point.matrixTransform(svg.getScreenCTM());

    // Add scroll offsets to convert viewport coords to document coords
    const left = screenPoint.x + window.scrollX + 10;  // 10px offset to right
    const top = screenPoint.y + window.scrollY - 10;   // 10px offset upward

    const tooltipText = circle.getAttribute('tooltip') || "";
    const processedText = tooltipText.replace(/\\n/g, '\n');

    const lines = processedText.split('\n');
    const title = lines[0];
    const body = lines.slice(1).join('<br>');

    dialog.innerHTML = `
      <div class="dialog-title">${title}</div>
      <div class="dialog-body">${body}</div>
    `;

    dialog.style.left = `${left}px`;
    dialog.style.top = `${top}px`;
    dialog.style.display = 'block';
  };

  // ✅ ADDED: Shared hide function
  const hideTooltip = () => {
    dialog.style.display = 'none';
  };

  // ✅ REPLACED: Original inline function with named function
  circle.addEventListener('mouseenter', showTooltip);
  circle.addEventListener('mouseleave', hideTooltip);
  circle.addEventListener('click', showTooltip); // tap/click fallback for emulators

  // ✅ ADDED: Mobile support using touchstart
  circle.addEventListener('touchstart', showTooltip);

  // ✅ ADDED: Hide tooltip when touching outside the element on mobile
  document.addEventListener('touchstart', (e) => {
    if (!circle.contains(e.target) && !dialog.contains(e.target)) {
      hideTooltip();
    }
  });

});
