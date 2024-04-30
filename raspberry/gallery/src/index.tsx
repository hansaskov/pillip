import { Elysia } from 'elysia'
import { html } from '@elysiajs/html'
import { staticPlugin } from '@elysiajs/static'
import { PhotoConfig, groupPhotoConfigsByDate, readPhotosFromPublicDirectory } from './photos';

export const staticAssetsFolder = 'static';
console.log(staticAssetsFolder)




export const BaseHtml = ({ children }: { children: undefined | {} }) => (
    <html lang="en">
        <head>
            <meta charset='utf-8' />
            <meta name="color-scheme" content="light dark" />
            <link rel="stylesheet" href={`${staticAssetsFolder}/css/pico.slate.min.css`} />
            <link rel="stylesheet" href={`${staticAssetsFolder}/css/main.css`} />
            <title>Hello World</title>
        </head>
        <body>
            <header>
                <Navbar />
            </header>
            <main class="container">
                {children}
            </main>
        </body>
    </html>
);

export const Navbar = () => (
    <nav class="container-fluid">
        <ul>
            <li><strong>Drone Corp</strong></li>
        </ul>
        <ul>
            <li><a href="#" class="contrast">About</a></li>
            <li><a href="#" class="contrast">Services</a></li>
            <li><a href="/" class="contrast">Photos</a></li>
        </ul>
    </nav>
)

export const PhotoConfigTable = ({ config }: { config: PhotoConfig }) => {

    const [date, time] = config.createDate.split(" ")

    return <>
        <table>
            <tr>
                <td>Date</td>
                <td>{date}</td>
            </tr>
            <tr>
                <td>Time</td>
                <td>{time}</td>
            </tr>
            <tr>
                <td>Time since epoch</td>
                <td>{config.createSecondsEpoc}</td>
            </tr>
            <tr>
                <td>Exposure time</td>
                <td>{config.exposureTime}</td>
            </tr>
            <tr>
                <td>Distance to subject</td>
                <td>{config.subjectDistance}</td>
            </tr>
            <tr>
                <td>ISO</td>
                <td>{config.ISO}</td>
            </tr>
            <tr>
                <td>Trigger method</td>
                <td>{config.trigger}</td>
            </tr>
        </table>
    </>
}

export const Photo = ({ config }: { config: PhotoConfig }) => {
    return (
        <>
            <img src={config.fileName} onclick="this.nextElementSibling.showModal()" />
            <dialog>
                <article>
                    <header>
                        <button aria-label="Close" rel="prev" onclick="this.closest('dialog').close()"></button>
                        <p>
                            <strong>Picture</strong>
                        </p>
                    </header>
                    <PhotoConfigTable config={config} />
                </article>
            </dialog>
        </>
    );
};

new Elysia()
    .use(staticPlugin({
        assets: staticAssetsFolder,
        prefix: `/${staticAssetsFolder}`
        
    }))
    .use(html())
    .get('/favicon.ico', () => Bun.file(`${staticAssetsFolder}/favicon.ico`))
    .get('/', async () => {
        const photoConfigs = await readPhotosFromPublicDirectory(`${staticAssetsFolder}/photos/`);
        const groupedPhotoConfigs = groupPhotoConfigsByDate(photoConfigs);
        return (
            <BaseHtml>
                {Object.entries(groupedPhotoConfigs).map(([date, configs]) => (
                    <hgroup>
                        <h2>{date}</h2>
                        <div class="grid-fluid">
                            {configs.map((config) => (
                                <>
                                    <Photo config={config} />
                                </>
                            ))}
                        </div>
                    </hgroup>

                ))}
            </BaseHtml>
        );
    })
    .listen(3000)