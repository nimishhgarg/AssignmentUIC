(function () {
    function injectStyles() {
        if (document.getElementById('MyPopupStyles')) return;

        const style = document.createElement('style');
        style.id = 'MyPopupStyles';
        style.textContent = `
.PopupMSG {
    background-color: white;
    opacity: 0;
    border: 1px solid #0B1020;
    backdrop-filter: blur(1px);
    -webkit-backdrop-filter: blur(1px);
    width: 70%;
    padding: 8px 12px;
    position: fixed;
    right: 3%;
    border-radius: 10px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 10px;
    transform: translateY(20px);
    transition: opacity 0.3s ease, transform 0.3s ease, top 0.3s ease;
    z-index: 999999;
    box-sizing: border-box;
}

.PopupMSG.MyPopup-show {
    opacity: 0.8;
    transform: translateY(0);
}

.PopupMSG-Head {
    font-size: 14px;
    color: #0B1020;
    font-family: uicbold;
    margin: 0;
}

.PopupMSG-Body {
    font-size: 11px;
    color: #777777;
    font-family: uic;
    margin: 0;
    line-height: 1.4;
    margin-top: 2px;
}

.PopupMSG-Close {
    cursor: pointer;
    flex-shrink: 0;
}
        `;
        document.head.appendChild(style);
    }

    function repositionPopups() {
        let top = typeof window.MyPopupTopOffset === 'number' ? window.MyPopupTopOffset : 80;
        window.MyPopupStack.forEach(function (el) {
            el.style.top = top + 'px';
            top += el.offsetHeight + 12;
        });
    }

    function closePopup(popup, timeoutId) {
        clearTimeout(timeoutId);
        popup.classList.remove('MyPopup-show');

        setTimeout(function () {
            popup.remove();
            window.MyPopupStack = window.MyPopupStack.filter(function (el) {
                return el !== popup;
            });
            repositionPopups();
        }, 300);
    }

    window.MyPopup = function (head, message) {
        injectStyles();

        if (!window.MyPopupStack) window.MyPopupStack = [];

        const popup = document.createElement('div');
        popup.className = 'PopupMSG';

        popup.innerHTML = `
            <div style="display: flex;align-items: flex-start;gap: 5px;">
                <div>
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#0B1020" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="icon icon-tabler icons-tabler-outline icon-tabler-exclamation-circle" style="margin-top: 1px;"><path stroke="none" d="M0 0h24v24H0z" fill="none" /><path d="M3 12a9 9 0 1 0 18 0a9 9 0 1 0 -18 0" /><path d="M12 9v4" /><path d="M12 16v.01" /></svg>
                </div>
                <div>
                    <div class="PopupMSG-Head"></div>
                    <div class="PopupMSG-Body"></div>
                </div>
            </div>
            <div class="PopupMSG-Close">
                <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#0B1020" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="icon icon-tabler icons-tabler-outline icon-tabler-x"><path stroke="none" d="M0 0h24v24H0z" fill="none" /><path d="M18 6l-12 12" /><path d="M6 6l12 12" /></svg>
            </div>
        `;

        popup.querySelector('.PopupMSG-Head').textContent = head;
        popup.querySelector('.PopupMSG-Body').textContent = message;

        document.body.appendChild(popup);
        window.MyPopupStack.push(popup);
        repositionPopups();

        requestAnimationFrame(function () {
            requestAnimationFrame(function () {
                popup.classList.add('MyPopup-show');
            });
        });

        const timeoutId = setTimeout(function () {
            closePopup(popup, timeoutId);
        }, 8000);

        popup.querySelector('.PopupMSG-Close').addEventListener('click', function () {
            closePopup(popup, timeoutId);
        });
    };
})();