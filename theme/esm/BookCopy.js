/**
 * 
 * @param {string} selectors 
 * @param {Element} context 
 */
function selectAll(selectors, context = null) {
  return Array.from(
    (context instanceof Element ? context : document).querySelectorAll(selectors)
  );
}

/**
 * 
 * @param {string} key 
 * @param {any} defaultValue 
 */
function readStorage(key, defaultValue) {
  let value;
  try {
    value = localStorage.getItem(key);
  } catch (e) {}

  return value != null ? value : defaultValue;
}

class Book {
  /**
   * @param {{ ace: any, cratesMatcherRE: RegExp }} env 
   */
  constructor(env) {
    const book = this;

    this.env = env;
    this.playpen = {
      /**
       * @param {Element} container 
       */
      read(container) {
        const code = container.querySelector('code');
    
        if (env.ace && code.classList.contains('editable')) {
          const editor = env.ace.edit(code);
          return editor.getValue();
        } else {
          return code.textContent;
        }
      },

      runSnippets() {
        const playpens = selectAll('.playpen');
        if (playpens.length > 0) {
          book.fetch(
            "https://play.rust-lang.org/meta/crates",
            {
              headers: {
                'Content-Type': "application/json",
              },
              method: 'POST',
              mode: 'cors',
            }
          )
          .then(res => res.json())
          .then(({ crates }) => {
            const playgroundCrates = crates.map(it => it.id);
            playpens.forEach(block => book.playpen.updateCrates(block, playgroundCrates));
          })
        }
      },

      /**
       * 
       * @param {Element} block 
       * @param {Object[]} crates 
       */
      updateCrates(block, crates) {

      },

      /**
       * 
       * @param {Element} block 
       * @param {string[]} crates 
       */
      updatePlayButton(block, crates) {
        const play = block.querySelector('.play-button');
        const code = block.querySelector('code');
        if (code.classList.contains('no_run')) {
          play.classList.add('hidden');
          return;
        }

        const content = book.playpen.read(block);
        const usedCrates = [];
        let matches;
        while (matches = book.env.cratesMatcherRE.exec(content)) {
          usedCrates.push(matches[1]);
        }

        const available = usedCrates.every(name => crates.indexOf(name) > -1);
        if (available) {
          play.classList.remove('hidden');
        } else {
          play.classList.add('hidden');
        }
      }
    }
  }

  /**
   * 
   * @param {string} feature 
   */
  has(feature) {
    return this.env[feature] != null;
  }

  /**
   * 
   * @param {string} url 
   * @param {Object} options 
   * @param {number} timeout 
   */
  fetch(url, options, timeout = 6000) {
    return Promise.race([
      fetch(url, options),
      new Promise((_ignore, reject) => {
        setTimeout(() => reject(new Error('timeout')), timeout)
      })
    ]);
  }
}